Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FC74550A9
	for <lists+io-uring@lfdr.de>; Wed, 17 Nov 2021 23:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241403AbhKQWow (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 17:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241317AbhKQWou (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 17:44:50 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B735C061570
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 14:41:51 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id i5so7630706wrb.2
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 14:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iBd9m/eWqCbNINMq039lGUeymJFcoXhPAalGlprkJ2o=;
        b=A/WtRx0+tN3ShHgy+48jxmppMKyap1tijsomShnvC1JrgfUA2as00vIW5eVJdGt2pI
         PRCLzzc6i/7Ff5jUbdEQb9q/J6LM0AalzwR9v2eQtJClzvRUJVNlCJPsIcZVBd/tFn7B
         vQka7uRoxk49M6AxlOa0QwL0b1Qz8V6XVoc4I6zCNIALNeclFWxPQVUw68O82f8JjUPI
         IrzyAfk19SJd5TKLicGyiQ7X8kkprm/KKK0BytdmjNq5ChHNLRowvM2NL1G0aiV103aW
         oCbEYpXF9OezOEo1P1WwbXAVyDZTT0iErwPwRR+UPchKURbcxzMBhTltREOuXbtEk9ra
         zJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iBd9m/eWqCbNINMq039lGUeymJFcoXhPAalGlprkJ2o=;
        b=1i35fTHiklIdz5FYiKax675VbmYuSSS3/cDK9gA1bittFdtoYLuHGJscYC2pvmfmzw
         csTe3zgGCfRD/YyvFqr5QjCaC0yXBl7ojALNBmqK2aAAWZxA08bky8pqao/HlMIcFyo/
         BPuRQrgzeHNyuCK3kWGFtkIs+N9Iwk9mDkHqP2xtA6ZRXN3J9aQI8SxbZ7toT4dwqR3z
         oJOn/ZsiYOB6wr7lTTYVsNodQBdABo7bsrfz0aJ5crssOV7HZBpzCfzjtS3V6T4M7PI/
         kjVt8wbFH4RODg5m1vAgOOe4PecqKRNSV3U75ziup3/YZmGjx6vy2XKE1AEYHMXs9mPZ
         oAzw==
X-Gm-Message-State: AOAM532fSBNUY4phIls2KzD5J1UrdMC2JlbeSY0DUfKn1SGA3tZsPCuX
        1NiovDEjotL2NXcB9283kKARr3s/KUU=
X-Google-Smtp-Source: ABdhPJwqI+3G5ldrBCdtpoGsxZ3F6msB+ItiogQwy0vDOrF9Zu37u6yLcVLTRWc52mkqh5/re/jiPw==
X-Received: by 2002:a05:6000:1889:: with SMTP id a9mr25920308wri.68.1637188910071;
        Wed, 17 Nov 2021 14:41:50 -0800 (PST)
Received: from [192.168.8.198] ([148.252.133.228])
        by smtp.gmail.com with ESMTPSA id t189sm985433wma.8.2021.11.17.14.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 14:41:49 -0800 (PST)
Message-ID: <154080f6-7264-5673-4fde-c901367de380@gmail.com>
Date:   Wed, 17 Nov 2021 22:41:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/6] io-wq: add helper to merge two wq_lists
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211029122237.164312-1-haoxu@linux.alibaba.com>
 <20211029122237.164312-2-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211029122237.164312-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/29/21 13:22, Hao Xu wrote:
> add a helper to merge two wq_lists, it will be useful in the next
> patches.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io-wq.h | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 41bf37674a49..a7b0b505db9d 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -52,6 +52,27 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
>   		list->last = node;
>   }
>   
> +/**
> + * wq_list_merge - merge the second list to the first one.
> + * @list0: the first list
> + * @list1: the second list
> + * Return list0 if list1 is NULL, and vice versa.
> + * Otherwise after merge, list0 contains the merged list.
> + */
> +static inline struct io_wq_work_list *wq_list_merge(struct io_wq_work_list *list0,
> +						    struct io_wq_work_list *list1)

might be easier if it'd be a splice or even initialising both lists
and returning a node ptr. E.g. (untested)

struct node* wq_list_splice(list0, list1) {
	struct node *ret;

	if (!list0->first) {
		ret = list1->first;
	} else {
		ret = list0->first;
		list0->last->next = list1->first;
	}

	init(list0);
	init(list1);
	return ret;
}

> +{
> +	if (!list1 || !list1->first)

Can also get rid of NULL checks, i.e. !list1

> +		return list0;
> +
> +	if (!list0 || !list0->first)
> +		return list1;
> +
> +	list0->last->next = list1->first;
> +	list0->last = list1->last;
> +	return list0;
> +}
> +
>   static inline void wq_list_add_tail(struct io_wq_work_node *node,
>   				    struct io_wq_work_list *list)
>   {
> 

-- 
Pavel Begunkov
