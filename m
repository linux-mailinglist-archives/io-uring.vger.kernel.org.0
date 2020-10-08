Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351E0287BA2
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 20:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgJHSX5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 14:23:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37296 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJHSX5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 14:23:57 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kQaa3-0003dS-IM; Thu, 08 Oct 2020 18:23:55 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: io_uring: process task work in io_uring_register()
Message-ID: <f7ac4874-9c6c-4f41-653b-b5a664bfc843@canonical.com>
Date:   Thu, 8 Oct 2020 19:23:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Static analysis with Coverity has detected a "dead-code" issue with the
following commit:

commit af9c1a44f8dee7a958e07977f24ba40e3c770987
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Sep 24 13:32:18 2020 -0600

    io_uring: process task work in io_uring_register()

The analysis is as follows:

9513                do {
9514                        ret =
wait_for_completion_interruptible(&ctx->ref_comp);

cond_const: Condition ret, taking false branch. Now the value of ret is
equal to 0.

9515                        if (!ret)
9516                                break;
9517                        if (io_run_task_work_sig() > 0)
9518                                continue;
9519                } while (1);
9520
9521                mutex_lock(&ctx->uring_lock);
9522

const: At condition ret, the value of ret must be equal to 0.
dead_error_condition: The condition ret cannot be true.

9523                if (ret) {

Logically dead code (DEADCODE)
dead_error_begin: Execution cannot reach this statement:

9524                        percpu_ref_resurrect(&ctx->refs);
9525                        ret = -EINTR;
9526                        goto out_quiesce;
9527                }
9528        }
9529

Colin
