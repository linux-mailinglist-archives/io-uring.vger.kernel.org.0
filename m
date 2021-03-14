Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B84433A49B
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 12:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbhCNLy5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 07:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhCNLyg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 07:54:36 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9139C061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 04:54:35 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id d191so6392233wmd.2
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 04:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=crZ6iFhAFv48iL+uOWovPqHFbCX6OgDWHokn6JKwJY0=;
        b=GJBmEuNgXawNOj/Egsx+Bo2cDgfROlIbhv5n3FLSXHujc0iplBIb3AZwJx5Psj2p0w
         61BzPSVg3PFl0rJcPPl8wuMhpO6AOfPs1VZnEJAS2R+sk2Xl3skS3OupMCtsuQMGXYx+
         aYv2w4YISOJzKbicsTjF66W7/hpFzoEWoEXOiFDQItswJRhnRr9XYwNYfa7f1l8NiF5T
         ZQOvKpfORSVj00k6IZI52ArJUSbbwFmDVauU2jTsFnZ4oUCshozHU453Grgqnsamw7Ta
         ON0IDD8VgcMiDKTSHNH+QAhuz/we3nj1jvIRuVD/eHmm89HVtRZSVvMQEPsZPrXjmR9Z
         RZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=crZ6iFhAFv48iL+uOWovPqHFbCX6OgDWHokn6JKwJY0=;
        b=TKLAAWToRb1qVhTprTvYN8n977Kf5Mrny2bKRrjGyD2/XBQ1iggd27lMkPMfPZrMbv
         YAdfwWI5Si6+KWlHUXbEx3uTNMJQpcuiBgL9qyysKXJYUfoX/phtNcVvttanzGgBnfMB
         dc+Qdp9J8jCfpKMwbr8YxhoippDk280CBHhkRkCT0RGQoVZTzubJ69EAdljkV9b+9KNw
         yC3o7BxFCB86Rbehaj8jo0mycBVjraRBIfQTYsC7sx2JJruGNWirsJJRq40U1AMyI9jK
         N5VkQpvCtrQRn2ESoExJ+/zm19y0X/8eliZc+Dn5qXBsPDnA7i88802h74wPr9puonWk
         TtsQ==
X-Gm-Message-State: AOAM532ImJDPaf9zwhzzLwYztiYPwovE7agf6dNe0gS+pbcLrUd+N+gO
        lojJqbKucUXzNddmUTgdxGvrmPyI14qrfQ==
X-Google-Smtp-Source: ABdhPJyGzzEIyICWCZVJYuCSUHgQrDF0C7hRKlupvnYIhhTGNelx6+jfiiDoxl/ruVzns786MwczSQ==
X-Received: by 2002:a1c:b4c6:: with SMTP id d189mr20997665wmf.72.1615722874045;
        Sun, 14 Mar 2021 04:54:34 -0700 (PDT)
Received: from [192.168.8.142] ([85.255.232.154])
        by smtp.gmail.com with ESMTPSA id x6sm9059784wmj.32.2021.03.14.04.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 04:54:33 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: remove structures from
 include/linux/io_uring.h
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1615719251.git.metze@samba.org>
 <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5c692b22-9042-14b4-1466-e4a209f15a7b@gmail.com>
Date:   Sun, 14 Mar 2021 11:50:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Both patches are really nice. However, 1/2 doesn't apply
and looks it needs small stylistic changes, see nits below

On 14/03/2021 11:15, Stefan Metzmacher wrote:
> ---
>  fs/io-wq.h               | 10 +++++++++-
>  fs/io_uring.c            | 16 ++++++++++++++++
>  include/linux/io_uring.h | 25 -------------------------
>  3 files changed, 25 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 1ac2f3248088..80d590564ff9 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -2,7 +2,6 @@
>  #define INTERNAL_IO_WQ_H
>   #include <linux/refcount.h>
> -#include <linux/io_uring.h>
>   struct io_wq;
>  @@ -21,6 +20,15 @@ enum io_wq_cancel {
>  	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
>  };

newline (nl)?

>  +struct io_wq_work_node {
> +	struct io_wq_work_node *next;
> +};
> +
> +struct io_wq_work_list {
> +	struct io_wq_work_node *first;
> +	struct io_wq_work_node *last;
> +};
> +
>  static inline void wq_list_add_after(struct io_wq_work_node *node,
>  				     struct io_wq_work_node *pos,
>  				     struct io_wq_work_list *list)
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 642ad08d8964..fd0807a3c9c3 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -454,6 +454,22 @@ struct io_ring_ctx {
>  	struct list_head		tctx_list;
>  };

nl

>  +struct io_uring_task {
> +	/* submission side */
> +	struct xarray		xa;
> +	struct wait_queue_head	wait;
> +	void			*last;
> +	void			*io_wq;
> +	struct percpu_counter	inflight;
> +	atomic_t		in_idle;
> +	bool			sqpoll;
> +
> +	spinlock_t		task_lock;
> +	struct io_wq_work_list	task_list;
> +	unsigned long		task_state;
> +	struct callback_head	task_work;
> +};
> +
>  /*
>   * First field must be the file pointer in all the
>   * iocb unions! See also 'struct kiocb' in <linux/fs.h>
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 9761a0ec9f95..79cde9906be0 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -5,31 +5,6 @@
>  #include <linux/sched.h>
>  #include <linux/xarray.h>
>  -struct io_wq_work_node {
> -	struct io_wq_work_node *next;
> -};
> -
> -struct io_wq_work_list {
> -	struct io_wq_work_node *first;
> -	struct io_wq_work_node *last;
> -};
> -
> -struct io_uring_task {
> -	/* submission side */
> -	struct xarray		xa;
> -	struct wait_queue_head	wait;
> -	void			*last;
> -	void			*io_wq;
> -	struct percpu_counter	inflight;
> -	atomic_t		in_idle;
> -	bool			sqpoll;
> -
> -	spinlock_t		task_lock;
> -	struct io_wq_work_list	task_list;
> -	unsigned long		task_state;
> -	struct callback_head	task_work;
> -};
> -

nl

>  #if defined(CONFIG_IO_URING)
>  struct sock *io_uring_get_socket(struct file *file);
>  void __io_uring_task_cancel(void);
> 

-- 
Pavel Begunkov
