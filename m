Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD7C1E242F
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 16:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgEZOfL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 10:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgEZOfJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 10:35:09 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736E1C03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 07:35:08 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c35so1529619edf.5
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 07:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UHCU1wRi0I0jqiY685xmbxpJCEv0pBt/N7kY2IxTHLg=;
        b=D119WYnmZaZXsDqDvGFhODuT/ibuqn9vy7FAIvxfVTxndDA99rBloYJGRCz5Cle80a
         eu09r4R345O+LdXQCejrbZEAQuasR2Z7lJmglSCZzah2OV2VyLHY1urT0s0mi1Iq6fLZ
         +qFnjKqQ+8iUS1LDrbrxs4OULhDsKhjJynWzp9rKf/VN0NZLPVeeJJlNNhXigh6r4rza
         CBHDl9aBkdLyas6Ko/OAvL4HHKXSmvkvM2qO9wDw5wkHm9vVWAhcnte9O0veq3Y8u/xD
         TlHRPhZlHiNZ/xuxYOQBxOZXo+idxyMYE/IegWA8He/hc/PHEmdTUnvbgVjaGkRGxl5Z
         Mytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UHCU1wRi0I0jqiY685xmbxpJCEv0pBt/N7kY2IxTHLg=;
        b=TBddXs1p9cP8dFYdf/LJutVUOENk7bOdKng6ITB22ED9ciNnGSeM5UIChVUFb4Yz6N
         47abndoWHXmmrQxr+kgDQaNppNVZ1m4VCcpuiqvdZVqIU1X/r7jph2RwGYL2F5IO0Bi2
         QKcm8uXU0fopqd/qGL7jFEnOPy2m9BgcBHcg51IRBNI7Jckyn8iUsMkeLDrPcdWbJWkS
         4Rn8cXpT5uW6xBjQKztsfq8dzj4UdGTx54fnZqpk5+bWN+o2shUID881jWROqPhYs11m
         jswPxNv4HSDz825Ec43MMZehaxdPp3o7I61jRLb310wzEK1s/XCPXanrCj80ecyH+lFy
         c4JQ==
X-Gm-Message-State: AOAM533qdGZXhQmGZWn6dWI2Rh5nACld5Au3hfkk71jeyXsU5KYIHRMa
        DAusBw4hR0mPxhUe14EkV0o=
X-Google-Smtp-Source: ABdhPJw/3xY8fiP+2Wox0zDRnZAxy+jhzlqyveezlsEk2MWB/+0wXn6w3TBRryKGDaySKLZLEe6KlA==
X-Received: by 2002:a05:6402:31b1:: with SMTP id dj17mr20257483edb.142.1590503707062;
        Tue, 26 May 2020 07:35:07 -0700 (PDT)
Received: from [192.168.43.105] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id c27sm103076ejd.19.2020.05.26.07.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 07:35:06 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/3] io_uring: don't use req->work.creds for inline
 requests
Message-ID: <fe4196c6-a069-a029-6a98-68801d088798@gmail.com>
Date:   Tue, 26 May 2020 17:33:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/05/2020 09:43, Xiaoguang Wang wrote:
> In io_init_req(), if uers requires a new credentials, currently we'll
> save it in req->work.creds, but indeed io_wq_work is designed to describe
> needed running environment for requests that will go to io-wq, if one
> request is going to be submitted inline, we'd better not touch io_wq_work.
> Here add a new 'const struct cred *creds' in io_kiocb, if uers requires a
> new credentials, inline requests can use it.
> 
> This patch is also a preparation for later patch.

What's the difference from keeping only one creds field in io_kiocb (i.e.
req->work.creds), but handling it specially (i.e. always initialising)? It will
be a lot easier than tossing it around.

Also, the patch doubles {get,put}_creds() for sqe->personality case, and that's
extra atomics without a good reason.

> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2af87f73848e..788d960abc69 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -635,6 +635,7 @@ struct io_kiocb {
>  	unsigned int		flags;
>  	refcount_t		refs;
>  	struct task_struct	*task;
> +	const struct cred	*creds;
>  	unsigned long		fsize;
>  	u64			user_data;
>  	u32			result;
> @@ -1035,8 +1036,10 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
>  		mmgrab(current->mm);
>  		req->work.mm = current->mm;
>  	}
> -	if (!req->work.creds)
> +	if (!req->creds)
>  		req->work.creds = get_current_cred();
> +	else
> +		req->work.creds = get_cred(req->creds);
>  	if (!req->work.fs && def->needs_fs) {
>  		spin_lock(&current->fs->lock);
>  		if (!current->fs->in_exec) {
> @@ -1368,6 +1371,9 @@ static void __io_req_aux_free(struct io_kiocb *req)
>  	if (req->flags & REQ_F_NEED_CLEANUP)
>  		io_cleanup_req(req);
>  
> +	if (req->creds)
> +		put_cred(req->creds);
> +
>  	kfree(req->io);
>  	if (req->file)
>  		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
> @@ -5673,13 +5679,13 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  again:
>  	linked_timeout = io_prep_linked_timeout(req);
>  
> -	if (req->work.creds && req->work.creds != current_cred()) {
> +	if (req->creds && req->creds != current_cred()) {
>  		if (old_creds)
>  			revert_creds(old_creds);
> -		if (old_creds == req->work.creds)
> +		if (old_creds == req->creds)
>  			old_creds = NULL; /* restored original creds */
>  		else
> -			old_creds = override_creds(req->work.creds);
> +			old_creds = override_creds(req->creds);
>  	}
>  
>  	ret = io_issue_sqe(req, sqe, true);
> @@ -5970,11 +5976,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  
>  	id = READ_ONCE(sqe->personality);
>  	if (id) {
> -		req->work.creds = idr_find(&ctx->personality_idr, id);
> -		if (unlikely(!req->work.creds))
> +		req->creds = idr_find(&ctx->personality_idr, id);
> +		if (unlikely(!req->creds))
>  			return -EINVAL;
> -		get_cred(req->work.creds);
> -	}
> +		get_cred(req->creds);
> +	} else
> +		req->creds = NULL;
>  
>  	/* same numerical values with corresponding REQ_F_*, safe to copy */
>  	req->flags |= sqe_flags;
> 

-- 
Pavel Begunkov
