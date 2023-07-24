Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF78B75FEBE
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 20:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjGXSEq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 14:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjGXSEo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 14:04:44 -0400
Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0726293;
        Mon, 24 Jul 2023 11:04:42 -0700 (PDT)
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from srv8.prv.sapience.com (srv8.prv.sapience.com [x.x.x.x])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by s1.sapience.com (Postfix) with ESMTPS id 1E47C480A67;
        Mon, 24 Jul 2023 14:04:42 -0400 (EDT)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1690221882;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=RGLhV90X2vD7WCHdvuHxxmk/VRfElb1rtPLIc+bMzqM=;
 b=xfmWdXz/zrOrxhpkBbIE7RbKn6LZ3TGWIxceNWUPif6PWIUNpUb3Dh3wVHGU7rHWgg50F
 j6RUDt+fxUEJvp4CA==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1690221882;
        cv=none; b=t3evAq+C8N+VhGXeTJFyF5JiQq4bRodHQYnz78VOIrNlC92Ke8zdd7s0TtJya4HjYe/eM8qGiSkZI9Vdit8i46zI65IG2f3d8gs6sP6Ah40CIhvy1CtJMtz1I6eWFj/maTMPH6Q7H3haF5fh2C5STG730U0AGtjPKKYuoQ7gLg6V6titPpFvjD/N7l7bY1lN/kSupvuZxQYTDQrkCQaJZ19BhJ4ETOJ3BC0DpHFYv7KCqmgrdFqJvQpD5eUjFnQilPwZpDylT/g52id6hFju6wI/UwzN+LSgeVbpUBeX0psu6SXOhK9tFPosnXU/nS79IJNXLzP+qI/W9AKZu4YewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
        t=1690221882; c=relaxed/simple;
        bh=jDpJEY6sD9HbgbWYLtsBNgGWP8y88MTr8X25y1O3kgI=;
        h=DKIM-Signature:DKIM-Signature:Message-ID:Date:MIME-Version:
         User-Agent:Subject:Content-Language:To:Cc:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding; b=FlVEpQ7hU+MCGJVIz4t24DpRTNQtUmogqO+Q0ZZTcyli/h5YtCpvrjd8amPdTXVRDgt3ReuKsLv3jXJvOFsnjB+rPkpVQv7CpK9aNp/I6CK4r5BwVn25AAb3YKxVQSNzBfh++Ruys0GEyjCYsbLiZ8lIO8DIf61JtSSxUIRo5X27vIvskVYpoMiSMbnRYi6f3n8nL9M3hvyAodE/IJ+LloX9izlV1MM1nzDxOJk8rZxZYhX1lu6bt1IeAp8pniVVRlP3weZp5QMxNKp3qSSA3dRcX4HW5iCUwWq+/NGFZwMVQqSXknirK8A926d7gZiwPYEyv4s532j+LPteot9YQw==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1690221882;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=RGLhV90X2vD7WCHdvuHxxmk/VRfElb1rtPLIc+bMzqM=;
 b=WTnKp7YFjqISsDCpDVMe3G8T+0+87U14zaFOrtPxNWTA4Ot+M8rFDm2lv48rO2WpI1aZB
 +SnTF6bbsGdVg6jZl1TXfTDscDC2giDQo6l+8C6ty7D6DK96ImCvbSuq6IJF88Id2nHCc95
 rIwQxdmxKAed0ogUp68VhGprafL0XhONxuYkETATNMIQdjOHBDhm746IIS11V8AA8DzKgTl
 Mw0P0vtRGVr2wrU7x/doWO8PqZUnB+iak5t9bzoDL10kJhkuUYRKpJFf30PQQmD/C4e9T1Z
 I9lp6bsFO+yhoRf0g+R5MpwdOakmc4GemkV694pdFAWof//sUM9Sp1d4sK2w==
Message-ID: <50d4bea8-4fbc-5c78-7b14-8bad32e25a05@sapience.com>
Date:   Mon, 24 Jul 2023 14:04:41 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>
References: <20230716194949.099592437@linuxfoundation.org>
 <538065ee-4130-6a00-dcc8-f69fbc7d7ba0@kernel.dk>
 <70e5349a-87af-a2ea-f871-95270f57c6e3@sapience.com>
 <2691683.mvXUDI8C0e@natalenko.name>
 <11ded843-ac08-2306-ad0f-586978d038b1@kernel.dk>
From:   Genes Lists <lists@sapience.com>
In-Reply-To: <11ded843-ac08-2306-ad0f-586978d038b1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/23 11:47, Jens Axboe wrote:

> It's not a behavioural change, it's a reporting change. There's no
> functionality changing here. That said, I do think we should narrow it a
> bit so we're only marked as in iowait if the task waiting has pending
> IO. That should still satisfy the initial problem, and it won't flag
> iowait on mariadb like cases where they have someone else just
> perpetually waiting on requests.
> 
> As a side effect, this also removes the flush that wasn't at all
> necessary on io_uring.
> 
> If folks are able to test the below, that would be appreciated.
> 
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 89a611541bc4..f4591b912ea8 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2493,11 +2493,20 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
>   	return 0;
>   }
>   
> +static bool current_pending_io(void)
> +{
> +	struct io_uring_task *tctx = current->io_uring;
> +
> +	if (!tctx)
> +		return false;
> +	return percpu_counter_read_positive(&tctx->inflight);
> +}
> +
>   /* when returns >0, the caller should retry */
>   static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   					  struct io_wait_queue *iowq)
>   {
> -	int token, ret;
> +	int io_wait, ret;
>   
>   	if (unlikely(READ_ONCE(ctx->check_cq)))
>   		return 1;
> @@ -2511,17 +2520,19 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   		return 0;
>   
>   	/*
> -	 * Use io_schedule_prepare/finish, so cpufreq can take into account
> -	 * that the task is waiting for IO - turns out to be important for low
> -	 * QD IO.
> +	 * Mark us as being in io_wait if we have pending requests, so cpufreq
> +	 * can take into account that the task is waiting for IO - turns out
> +	 * to be important for low QD IO.
>   	 */
> -	token = io_schedule_prepare();
> +	io_wait = current->in_iowait;
> +	if (current_pending_io())
> +		current->in_iowait = 1;
>   	ret = 0;
>   	if (iowq->timeout == KTIME_MAX)
>   		schedule();
>   	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
>   		ret = -ETIME;
> -	io_schedule_finish(token);
> +	current->in_iowait = io_wait;
>   	return ret;
>   }
>   
> 
Tested on top of 6.4.6 stable - and working great - iowait stats now 
look like they always did.

thank you

gene
