Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6834448C7
	for <lists+io-uring@lfdr.de>; Wed,  3 Nov 2021 20:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhKCTNW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Nov 2021 15:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhKCTNW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Nov 2021 15:13:22 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898B1C061714
        for <io-uring@vger.kernel.org>; Wed,  3 Nov 2021 12:10:45 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id s19-20020a056830125300b0055ad9673606so3663557otp.0
        for <io-uring@vger.kernel.org>; Wed, 03 Nov 2021 12:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hPDEOCN2iqOZpizNkjJYUsyv6b0bDmWcHevIM96ciNI=;
        b=Qm7Iy0gi7zCeD/IQhpJ6W8XeETRVcpn4mr3m6dFyxznMeDH7OrYwfwBz+Z5onjqjAr
         EMYtjUCj7oi0sRixoSXNazETULbPmVmEnlImkk5xpkjfJJLRT1188f6eor5zdgHEU4EC
         e0sBKOwtwCwKlCugCdgSwlMA+NyKxmm9f2gP9lwFTNKs8CdtO2X2alEJLWivCHB0PGjQ
         AYDEqknjl3oysWv62ZSM7XMwhKKGPknSEwlkHTawHp2Fr8cLgoG1yWwnehwDZ2gyeiB1
         2UR+AY3K4bFQ2gS/3Yp6jR7VqOlEAvgthPGADCwY5zGRD7cWC20BRjCjKhVdP0ruU6dL
         jfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hPDEOCN2iqOZpizNkjJYUsyv6b0bDmWcHevIM96ciNI=;
        b=iaHTTGe2NFJWnL4qIpSRDYP9JhM6GTD5z6WBgSIokd1/0Nkc++vXfRE+0PP1PJwEe4
         HZHCUvL23IeBURVddJm/iyEQKLYQbsKixSEv0LZOzULTNXWgWMfb3fmPTmZTYsAYHJ1F
         bppGYie2Qibae+Z92+s0J7fLalBzykTICm3NN4k4AMBnP/ki7W8DQOf71Rv0u0T/hqnH
         AEY3AD/DoSrg00Xmq/FPiX7eANfKsJNCj9IwRywnxW+Oo8m9q4uGle7jBZo8rkNeSMRe
         q31AWM/9agcDBBFQCisiLdT6Sp+bOosNRyaGXdGzG08bL+avyy/DYUh3talnG2f3BkvJ
         Q8/g==
X-Gm-Message-State: AOAM531kzIWz4E/WhAgzguqS2Kcp963DGD0Wf/afT/vPGd6ELOEpT3vl
        p5NRI0R3xSFeSMAU0gQBVSONfmF7KPuRTQ==
X-Google-Smtp-Source: ABdhPJxvYsZulGOlfjkEIVrY4Je5In76ALURvsPAsWceEcScKVbjmZer6qOzrsyldVLVJedDAt0iJg==
X-Received: by 2002:a05:6830:12d6:: with SMTP id a22mr27654448otq.288.1635966644854;
        Wed, 03 Nov 2021 12:10:44 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q1sm876578oiw.17.2021.11.03.12.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 12:10:44 -0700 (PDT)
Subject: Re: [RFC] io-wq: decouple work_list protection from the big wqe->lock
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211031104945.224024-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <df8a6142-73f5-32e1-6ffd-7de1093abab9@kernel.dk>
Date:   Wed, 3 Nov 2021 13:10:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211031104945.224024-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/31/21 4:49 AM, Hao Xu wrote:
> @@ -380,10 +382,14 @@ static void io_wqe_dec_running(struct io_worker *worker)
>  	if (!(worker->flags & IO_WORKER_F_UP))
>  		return;
>  
> +	raw_spin_lock(&acct->lock);
>  	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
> +		raw_spin_unlock(&acct->lock);
>  		atomic_inc(&acct->nr_running);
>  		atomic_inc(&wqe->wq->worker_refs);
>  		io_queue_worker_create(worker, acct, create_worker_cb);
> +	} else {
> +		raw_spin_unlock(&acct->lock);
>  	}
>  }

I think this may be more readable as:

static void io_wqe_dec_running(struct io_worker *worker)
	__must_hold(wqe->lock)
{
	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
	struct io_wqe *wqe = worker->wqe;

	if (!(worker->flags & IO_WORKER_F_UP))
		return;
	if (!atomic_dec_and_test(&acct->nr_running))
		return;

	raw_spin_lock(&acct->lock);
	if (!io_acct_run_queue(acct)) {
		raw_spin_unlock(&acct->lock);
		return;
	}

	raw_spin_unlock(&acct->lock);
	atomic_inc(&acct->nr_running);
	atomic_inc(&wqe->wq->worker_refs);
	io_queue_worker_create(worker, acct, create_worker_cb);
}

?

Patch looks pretty sane to me, but there's a lot of lock shuffling going
on for it. Like in io_worker_handle_work(), and particularly in
io_worker_handle_work(). I think it'd be worthwhile to spend some time
to see if that could be improved. These days, lock contention is more
about frequency of lock grabbing rather than hold time. Maybe clean
nesting of wqe->lock -> acct->lock (which would be natural) can help
that?

-- 
Jens Axboe

