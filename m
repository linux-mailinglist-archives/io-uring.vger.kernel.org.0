Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7720192A88
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2020 14:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgCYN4H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Mar 2020 09:56:07 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:34024 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727277AbgCYN4H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Mar 2020 09:56:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Ttby5Zv_1585144554;
Received: from 30.5.113.160(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Ttby5Zv_1585144554)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 25 Mar 2020 21:55:54 +0800
To:     io-uring@vger.kernel.org
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        joseph qi <joseph.qi@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Question about fileset unregister and update codes
Message-ID: <64638b5f-401e-5cf4-23d9-0a31119d1b9c@linux.alibaba.com>
Date:   Wed, 25 Mar 2020 21:55:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

Look at below function:
static bool io_register_op_must_quiesce(int op)
{
	switch (op) {
	case IORING_UNREGISTER_FILES:
	case IORING_REGISTER_FILES_UPDATE:
	case IORING_REGISTER_PROBE:
	case IORING_REGISTER_PERSONALITY:
	case IORING_UNREGISTER_PERSONALITY:
		return false;
	default:
		return true;
	}
}

IORING_REGISTER_FILES will quiesces the ctx, but IORING_UNREGISTER_FILES
and IORING_REGISTER_FILES_UPDATE won't, so I wonder how userspace applications
can sure when they can unregister or update the registered fileset.
Imagine below application behaviour:
      ThreadA                     |      ThreadB
                                  |
     1, register a file           |     while (1) {
     2, prepare a batch of sqes   |         wait a cqe and handle this cqe.
     3, submit prepared sqes      |     }
     4, unregister or update file |
                                  |

If IORING_SETUP_SQPOLL is not enabled, I think step4 is safe, because step3
will ensure that all sqes will be prepared by io_req_set_file(), then corresponding
struct file will be resolved and ctx->file_data->refs will be increased, we know
unless requst is completed, struct file will not be put, finally we know step4
is safe.

But if IORING_SETUP_SQPOLL is enabled, step3 will complete quickly, if kernel
thread io_sq_thread submit sqes before step4, everything is ok, but if step4
starts to run, holding uring_lock, later io_sq_thread starts to handle sqes and
all previously submitted sqes will be returned with EBADF.

I'm not sure whether should make application ensure that all sqes against registered
file to complete, then app can unregister or update fileset, if so, I think it'll
introduce extra programming overhead to programmer.

Or if IORING_SETUP_SQPOLL is enabled, we call io_submit_sqes in unregister/update codes,
then applications will not need to worry about above race.

Regards,
Xiaoguang Wang
