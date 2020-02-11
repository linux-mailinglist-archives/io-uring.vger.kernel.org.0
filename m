Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60278158906
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 04:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgBKDuG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 22:50:06 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40871 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgBKDuG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 22:50:06 -0500
Received: by mail-pj1-f65.google.com with SMTP id 12so639994pjb.5
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 19:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D/M0oktd0/AZk2q1+ON19hhJRS69UlkgBMVmZWpt/qc=;
        b=hloY6eC+He3n55KNyEHKtUeYTr5TZOcejIIKkypfx20Uc43dX+tLfVhSnxdAERderV
         RoRW9+688RIvV1rnNXi6MVI9tWGJj5j/R0At64ntaR5XMdxF/4OCngbjF5yHgLivaaEz
         8DzTYC1iAGa0XrzKsdQtNoy2hICJp7XY5p+d5hijZtvQBSmjGrHtfJ8dtl5QP31qLmLm
         IO7JHdk9PFQC4qZhhYQqk1SWNRgEUAGuog6SaWzjMCCmZjY6W5kBT02n7mO+BklyJdGc
         cfZniMBPIVhz4X7ivl4/0NFgyXOQUydiftYzztKaiS3M9h5BSoyW+zn20/JCL1uvHu5A
         RJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D/M0oktd0/AZk2q1+ON19hhJRS69UlkgBMVmZWpt/qc=;
        b=CDx+PdEtpWzZk1H7yJenLKhz9EzysZLRcVl0nXmuC5DagT0Zxh7yVQ/M1tt53qxupw
         AxQZEZ103j1L1k9SVSybGDk278YusliKMxwG937x98C10+Fp7ETI7pf6eZkmPXrD/FVv
         RvCF2wobGyUkAt3QKO9SbWN8InSqqmAITI2gpZK1rNhcfhkgVumWwB7gajrUvG137Ky8
         JFqGfjwO5CIy9h2fwY1Zrc6zApdL+AP684sujvGcHJ4Ux5YL++CK9T3jdFd22PWaNYOt
         +P1t8SGAG/QeVpm+HjSoRKTCvtLos/fEHTRUwGWxC91i8UBp0iZ3C5c8eioRJ7Y9Mmfx
         eucw==
X-Gm-Message-State: APjAAAWwW2M6P/C9KTQyMNJvxK8NLsS67mjFeXI1eOeJu+mmun+bCvuN
        L/+5dL8cbSiESAf0i52d3jPGmMdsUSo=
X-Google-Smtp-Source: APXvYqyy6w8Y3DH3TsCFmFSBBNkqzuEPowNML8+Jlxw5tIJJgV1Zf8wnSU3Xmcehm23Sj21E+NelKg==
X-Received: by 2002:a17:90a:178f:: with SMTP id q15mr1356741pja.132.1581393005725;
        Mon, 10 Feb 2020 19:50:05 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id o16sm1537618pgl.58.2020.02.10.19.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 19:50:05 -0800 (PST)
Subject: Re: Kernel BUG when registering the ring
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
 <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk>
 <CAD-J=zYNXej09AarnJDqgvX5U5aNLh4ez6hddWzWvg-625c1mA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c192d9b8-fab9-1c29-7266-acd48b380338@kernel.dk>
Date:   Mon, 10 Feb 2020 20:50:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zYNXej09AarnJDqgvX5U5aNLh4ez6hddWzWvg-625c1mA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/20 8:45 PM, Glauber Costa wrote:
> It crashes all the same
> 
> New backtrace attached - looks very similar to the old one, although
> not identical.

I missed the other spot we do the same thing... Try this.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 182aa17dc2ca..b8ef5a5483de 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1115,12 +1116,15 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 	for_each_node(node) {
 		struct io_wqe *wqe;
+		int alloc_node = node;
 
-		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, node);
+		if (!node_online(alloc_node))
+			alloc_node = NUMA_NO_NODE;
+		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
 		if (!wqe)
 			goto err;
 		wq->wqes[node] = wqe;
-		wqe->node = node;
+		wqe->node = alloc_node;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
 		if (wq->user) {
@@ -1128,7 +1132,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 					task_rlimit(current, RLIMIT_NPROC);
 		}
 		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
-		wqe->node = node;
 		wqe->wq = wq;
 		spin_lock_init(&wqe->lock);
 		INIT_WQ_LIST(&wqe->work_list);

-- 
Jens Axboe

