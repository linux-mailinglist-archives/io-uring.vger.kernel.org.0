Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2FE52764D
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 09:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbiEOHjA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 03:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiEOHi7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 03:38:59 -0400
X-Greylist: delayed 422 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 15 May 2022 00:38:58 PDT
Received: from pv50p00im-zteg10011501.me.com (pv50p00im-zteg10011501.me.com [17.58.6.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC8D15FD3
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 00:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652599915;
        bh=HYHjRFiUZ7q+/RkyrEArH6sapMfkanketQZiO9aYWqA=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=gJX7tm1zPlOMYgqyQ+zcXl8kbR5gGQ8jIIBGBtJOKjWr8p3sXbQImfNhqoItzEzK/
         sPdqXWqVosGHcGcBcDBlU2P9/9Ix4IapCCBQ3ZF+K2fjM/eSuJzuXOx7WhrqnE6dMj
         1DjQvlf7M2YBr+0Aw4jquyBhR/Fyvxe2oMsHKIPglxIJDj8nZfDr6ZK1SIRX5MDX8p
         gSpMK6zAEteKCMVaMVFyD3xQBl1wE1B2mATce+Svp82Du9NMz6dVrnMdmspE3Z5J8o
         ISFMMDh7bt4WpNel7Qa7LATbIQrwtXHGgnSSvDPXI8sWueEf+/hYqRk8Ux5jrKjLYO
         BEtr9ZTYqS6sw==
Received: from [192.168.31.208] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-zteg10011501.me.com (Postfix) with ESMTPSA id 847D72E02D8;
        Sun, 15 May 2022 07:31:53 +0000 (UTC)
Message-ID: <5b4e6d37-f25d-099a-81a7-9125eb958251@icloud.com>
Date:   Sun, 15 May 2022 15:31:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: avoid iowq again trap
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_04:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=846 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205150035
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/22 18:24, Pavel Begunkov wrote:
> If an opcode handler semi-reliably returns -EAGAIN, io_wq_submit_work()

Hi Pavel,
When would it return -EAGAIN in non-IOPOLL mode?

> might continue busily hammer the same handler over and over again, which
> is not ideal. The -EAGAIN handling in question was put there only for
> IOPOLL, so restrict it to IOPOLL mode only.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e01f595f5b7d..3af1905efc78 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7319,6 +7319,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   		 * wait for request slots on the block side.
>   		 */
>   		if (!needs_poll) {
> +			if (!(req->ctx->flags & IORING_SETUP_IOPOLL))
> +				break;
>   			cond_resched();
>   			continue;
>   		}

