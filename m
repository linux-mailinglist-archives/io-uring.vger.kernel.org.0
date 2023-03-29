Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9C16CD067
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 04:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjC2C6B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 22:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjC2C57 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 22:57:59 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4147D1FD2;
        Tue, 28 Mar 2023 19:57:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VeuzJcJ_1680058673;
Received: from 30.97.56.166(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VeuzJcJ_1680058673)
          by smtp.aliyun-inc.com;
          Wed, 29 Mar 2023 10:57:54 +0800
Message-ID: <2e3c20e0-a0be-eaf3-b288-c3c8fa31d1fa@linux.alibaba.com>
Date:   Wed, 29 Mar 2023 10:57:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH V5 16/16] block: ublk_drv: apply io_uring FUSED_CMD for
 supporting zero copy
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dan Williams <dan.j.williams@intel.com>
References: <20230328150958.1253547-1-ming.lei@redhat.com>
 <20230328150958.1253547-17-ming.lei@redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20230328150958.1253547-17-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/3/28 23:09, Ming Lei wrote:
> Apply io_uring fused command for supporting zero copy:
> 

[...]

>  
> @@ -1374,7 +1533,12 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  	if (!ubq || ub_cmd->q_id != ubq->q_id)
>  		goto out;
>  
> -	if (ubq->ubq_daemon && ubq->ubq_daemon != current)
> +	/*
> +	 * The fused command reads the io buffer data structure only, so it
> +	 * is fine to be issued from other context.
> +	 */
> +	if ((ubq->ubq_daemon && ubq->ubq_daemon != current) &&
> +			(cmd_op != UBLK_IO_FUSED_SUBMIT_IO))
>  		goto out;
>  

Hi Ming,

What is your use case that fused io_uring cmd is issued from another thread?
I think it is good practice to operate one io_uring instance in one thread
only.

Regards,
Zhang
