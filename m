Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305362E768E
	for <lists+io-uring@lfdr.de>; Wed, 30 Dec 2020 07:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgL3G3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Dec 2020 01:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgL3G3y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Dec 2020 01:29:54 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1248C061799;
        Tue, 29 Dec 2020 22:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=SfTFgLP6wfqdV3POETz9tGdMTER4p/HPo53xEwUv884=; b=dcxUcAlZaUg6/xLLgmP2V7b3AT
        OrjzzTQiEMt+yBXhVSd017ynS1Ey+DdQP64HMK2sUGmPi+a0uEpZM+6fhZ8lcWnpHYZ/iUcT1kkB/
        zcC5bWFI3050e/zvK2M3fR/F5CGKNCVt3F/jZqA9ffWVOiZq0MsR/w8f4KdQrdwMmb46g54ZDYAqX
        mUJTXqUYflT4Kl9F0NagIEbke1kpvkwNCWGD3IOOiM6ic/CSaKtLhNz+OupyW8iZiwIwf5+moApdH
        aXuWL6yPGO2BvSxx2eZ7QYTYzWUy4s61rEFMlkoC2dECi6rcwWbA3mv9uxSF8iwm6ndsWo5oZRGuJ
        fseZO6Bg==;
Received: from [2601:1c0:6280:3f0::2c43]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kuUys-0002PI-4F; Wed, 30 Dec 2020 06:29:10 +0000
Subject: Re: [PATCH] io_uring: style: redundant NULL check.
To:     YANG LI <abaci-bugfix@linux.alibaba.com>, axboe@kernel.dk
Cc:     viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1609309375-65129-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <bb01e932-9b93-c672-2e76-d8a2918d5bd6@infradead.org>
Date:   Tue, 29 Dec 2020 22:29:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1609309375-65129-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/29/20 10:22 PM, YANG LI wrote:
> If the pointer in kfree is empty, the function does nothing,
> so remove the redundant NULL check.
> 
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>
> ---

Looks like you should do something with these 2 comments:

 	/* it's reportedly faster than delegating the null check to kfree() */

>  fs/io_uring.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7e35283..105e188 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1934,8 +1934,8 @@ static void io_dismantle_req(struct io_kiocb *req)
>  {
>  	io_clean_op(req);
>  
> -	if (req->async_data)
> -		kfree(req->async_data);
> +	kfree(req->async_data);
> +
>  	if (req->file)
>  		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
>  	if (req->fixed_file_refs)
> @@ -3537,8 +3537,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>  	ret = 0;
>  out_free:
>  	/* it's reportedly faster than delegating the null check to kfree() */
> -	if (iovec)
> -		kfree(iovec);
> +	kfree(iovec);
>  	return ret;
>  }
>  
> @@ -3644,8 +3643,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>  	}
>  out_free:
>  	/* it's reportedly faster than delegating the null check to kfree() */
> -	if (iovec)
> -		kfree(iovec);
> +	kfree(iovec);
>  	return ret;
>  }
>  
> @@ -6133,8 +6131,7 @@ static void __io_clean_op(struct io_kiocb *req)
>  		case IORING_OP_WRITE_FIXED:
>  		case IORING_OP_WRITE: {
>  			struct io_async_rw *io = req->async_data;
> -			if (io->free_iovec)
> -				kfree(io->free_iovec);
> +			kfree(io->free_iovec);
>  			break;
>  			}
>  		case IORING_OP_RECVMSG:
> 


-- 
~Randy

