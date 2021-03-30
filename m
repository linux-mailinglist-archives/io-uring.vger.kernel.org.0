Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DF034F12B
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 20:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhC3Soz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 14:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbhC3Sol (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 14:44:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CDEC061574
        for <io-uring@vger.kernel.org>; Tue, 30 Mar 2021 11:44:40 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o16so17266376wrn.0
        for <io-uring@vger.kernel.org>; Tue, 30 Mar 2021 11:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=umuufMY1bgOKQLlRwDVWTMXrCf/G01wrflIkNhx3fk8=;
        b=fFx2nmzwC/ga25woZeNzvooYePUJ0EtsqIRGo1oc1INIxF1ZuNKdASIjMMBqwWAHOQ
         QmUuG6rznp+kwF5FvvzKEAlSyZa9yL4zcQEc3qu7tU8U/Jy9MnatcWhDmxwaAk5oqMqS
         uX5idyqRTYcVUXk2+boZEqdsv8kGp+zlmSOF3fk3WtRk7Mk6HfQNzHdUTLSR9kEM9KJ2
         9q+6qQOeX1ppKoWAWTvd2QqeaHHC08zwcbNJLTrO6kIlwZVpQ9Bt6mXIhQfxuMYlQ+IS
         alg8ezDvwChv9Ju4Ro/KjmmCZZb7Rv3QL+ce2N3+12dwPwmlNESislMRjsoxRWCRthEq
         nHMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=umuufMY1bgOKQLlRwDVWTMXrCf/G01wrflIkNhx3fk8=;
        b=Bdy+8wuw/3V6h3AX7COpM7GIrCkHBEEfcoxpdRhSnv8FHGfitAEAsWN34TklNnjQkE
         17bhU3f8iMi9uMRu4Gnrhjx9s7F3va7sA8pvCsrSfZcZboUhXIQpwxvaEiFwT/EuPJGk
         kJ00rc9jZ93m9vYq+oKe922iexkmbViPBV+4hIZasJ3HQtCnYXqRwDw82huk4ESBVnmL
         f6w1zltytjIOjoQ9gbnvgWzVrYxZP2VRpTxFhF/kfATzm9d4QxFiscSYR9WV4FFzXNYh
         b2pNIke+mxXLC5l1mdI4jwObFOC2QGTevEUSTGEftHqrqFIZtAlKLg+H0d0UDnPt/B7C
         iBTw==
X-Gm-Message-State: AOAM533TlQp7h5Yljjhpt6jJStEkFZ+jmlvIi/V/x7EaBGMnlRg8X+YS
        G3LYswjuE70y6rLu5nipgMeAoxeovpH81g==
X-Google-Smtp-Source: ABdhPJyGKklgv+tI8eZXBpNrprIEWaney5E5RMOpbcJfwF1NY+mpe2P72+2XcEwRf+kgVZQ/REjbDw==
X-Received: by 2002:a5d:4523:: with SMTP id j3mr36330236wra.288.1617129879367;
        Tue, 30 Mar 2021 11:44:39 -0700 (PDT)
Received: from [192.168.8.120] ([85.255.234.174])
        by smtp.gmail.com with ESMTPSA id g11sm36244806wrw.89.2021.03.30.11.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 11:44:39 -0700 (PDT)
Subject: Re: [PATCH 1/1] io-wq: forcefully cancel on io-wq destroy
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <822eeb713e57efe8960a7f3a7c11dbef1fcbf4e4.1617129472.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <2f85b4f1-80f3-44e7-60ff-c3f2e2fb93ab@gmail.com>
Date:   Tue, 30 Mar 2021 19:40:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <822eeb713e57efe8960a7f3a7c11dbef1fcbf4e4.1617129472.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/03/2021 19:38, Pavel Begunkov wrote:
> [  491.222908] INFO: task thread-exit:2490 blocked for more than 122 seconds.
> [  491.222957] Call Trace:
> [  491.222967]  __schedule+0x36b/0x950
> [  491.222985]  schedule+0x68/0xe0
> [  491.222994]  schedule_timeout+0x209/0x2a0
> [  491.223003]  ? tlb_flush_mmu+0x28/0x140
> [  491.223013]  wait_for_completion+0x8b/0xf0
> [  491.223023]  io_wq_destroy_manager+0x24/0x60
> [  491.223037]  io_wq_put_and_exit+0x18/0x30
> [  491.223045]  io_uring_clean_tctx+0x76/0xa0
> [  491.223061]  __io_uring_files_cancel+0x1b9/0x2e0
> [  491.223068]  ? blk_finish_plug+0x26/0x40
> [  491.223085]  do_exit+0xc0/0xb40
> [  491.223099]  ? syscall_trace_enter.isra.0+0x1a1/0x1e0
> [  491.223109]  __x64_sys_exit+0x1b/0x20
> [  491.223117]  do_syscall_64+0x38/0x50
> [  491.223131]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  491.223177] INFO: task iou-mgr-2490:2491 blocked for more than 122 seconds.
> [  491.223194] Call Trace:
> [  491.223198]  __schedule+0x36b/0x950
> [  491.223206]  ? pick_next_task_fair+0xcf/0x3e0
> [  491.223218]  schedule+0x68/0xe0
> [  491.223225]  schedule_timeout+0x209/0x2a0
> [  491.223236]  wait_for_completion+0x8b/0xf0
> [  491.223246]  io_wq_manager+0xf1/0x1d0
> [  491.223255]  ? recalc_sigpending+0x1c/0x60
> [  491.223265]  ? io_wq_cpu_online+0x40/0x40
> [  491.223272]  ret_from_fork+0x22/0x30
> 
> When io-wq worker exits and sees IO_WQ_BIT_EXIT it tries not cancel all
> left requests but to execute them, hence we may wait for the exiting
> task for long until someone pushes it, e.g. with SIGKILL. Actively
> cancel pending work items on io-wq destruction.

The trace is from slightly modified thread-exit, and it doesn't
hang forever, but can be killed with ctrl+c or whatever. Also,
predictably breaks thread-exit test. 


> 
> note: io_run_cancel() moved up without any changes.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io-wq.c | 50 +++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 35 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 7434eb40ca8c..5fa5e0fd40d6 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -342,6 +342,20 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
>  	spin_unlock(&wq->hash->wait.lock);
>  }
>  
> +static struct io_wq_work *io_get_work_all(struct io_wqe *wqe)
> +	__must_hold(wqe->lock)
> +{
> +	struct io_wq_work_list *list = &wqe->work_list;
> +	struct io_wq_work_node *node = list->first;
> +	int i;
> +
> +	list->first = list->last = NULL;
> +	for (i = 0; i < IO_WQ_NR_HASH_BUCKETS; i++)
> +		wqe->hash_tail[i] = NULL;
> +
> +	return node ? container_of(node, struct io_wq_work, list) : NULL;
> +}
> +
>  static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
>  	__must_hold(wqe->lock)
>  {
> @@ -410,6 +424,17 @@ static void io_assign_current_work(struct io_worker *worker,
>  
>  static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
>  
> +static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
> +{
> +	struct io_wq *wq = wqe->wq;
> +
> +	do {
> +		work->flags |= IO_WQ_WORK_CANCEL;
> +		wq->do_work(work);
> +		work = wq->free_work(work);
> +	} while (work);
> +}
> +
>  static void io_worker_handle_work(struct io_worker *worker)
>  	__releases(wqe->lock)
>  {
> @@ -518,11 +543,17 @@ static int io_wqe_worker(void *data)
>  	}
>  
>  	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
> +		struct io_wq_work *work, *next;
> +
>  		raw_spin_lock_irq(&wqe->lock);
> -		if (!wq_list_empty(&wqe->work_list))
> -			io_worker_handle_work(worker);
> -		else
> -			raw_spin_unlock_irq(&wqe->lock);
> +		work = io_get_all_items(wqe);
> +		raw_spin_unlock_irq(&wqe->lock);
> +
> +		while (work) {
> +			next = wq_next_work(work);
> +			io_get_work_all(work, wqe);
> +			work = next;
> +		}
>  	}
>  
>  	io_worker_exit(worker);
> @@ -748,17 +779,6 @@ static int io_wq_manager(void *data)
>  	do_exit(0);
>  }
>  
> -static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
> -{
> -	struct io_wq *wq = wqe->wq;
> -
> -	do {
> -		work->flags |= IO_WQ_WORK_CANCEL;
> -		wq->do_work(work);
> -		work = wq->free_work(work);
> -	} while (work);
> -}
> -
>  static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
>  {
>  	unsigned int hash;
> 

-- 
Pavel Begunkov
