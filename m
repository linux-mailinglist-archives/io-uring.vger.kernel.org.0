Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DFD1588CB
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 04:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgBKDZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 22:25:32 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42117 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgBKDZc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 22:25:32 -0500
Received: by mail-pl1-f193.google.com with SMTP id e8so3650017plt.9
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 19:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=b2qd2Zkk6mE5KR+wlY6RQjmUx4S8LNM8NVgdHHuRTZo=;
        b=Z2sPNSHiXp2feGankfQNQCDhfIliyCbbtMnZcAz8qlwcpy6LorFJvvRbK5nlJd+ejA
         hema4vGKr6NmsdeBOYE6XVmvFFMeby9S04NSexZdxUxZfwY5ACwy+iDDop6RB8o+fyFt
         UID1vrRZOXjBa9nPiYqc1mwjBirnMXLoJWez65VZqH5s7AXJZdzDykyT+/wmhkYHNulf
         fD9Uh77YpzE8QcbsvhGM0VMHjx7sJxcLjrNHC7Gy9koQq9Mn/eeD2UIeIsjLWNRr3L+v
         bPVELzSluaI2/wdFciSN298S7ZvqFVYSqUFAMf3JdLpBtp/PE5YjKqDu8lJ5afdbu1Gq
         zovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b2qd2Zkk6mE5KR+wlY6RQjmUx4S8LNM8NVgdHHuRTZo=;
        b=lQ6oH5vlGvObYqlXsMXnABIjrpwq4AcwzFIpvuM+3kaf0drYuIgtFEzdINCi2pJU/B
         gc+WW+qahyY7NIfPDpBSvIu+uAs1hYDtdcBTjyjDvLr3C9JWndaeXxJIzNJx8u7/Gj4E
         vGjwc3YZvH82s9s+ibHdAua3C2hW7ZzuluPs/qHmxZqU3VhIAiMvC7oL1cAGYueLPSFL
         H0uFztJkMY0ulBKJdBFENvtxhb0HPBgAreGd2iq5ewvy+lLYIg2QcTGemzt29XTT/wK3
         8r8gbws1Je71I0jbvsu9virsjjVr7A30PZtkGOe9VHuLiN2WN2LQAadqBDhaS7TUwMNf
         QbRA==
X-Gm-Message-State: APjAAAUyaMOXKEFc+pU1w9KzADnvP6tpTRI0hrQbZ7UxhXmJzwz6Dy6d
        sM74oRTwtTFuKho8fac6bmY8gA==
X-Google-Smtp-Source: APXvYqzftiMzu1lkWXECwo4E2fyyAKoMBiYzgxdehwHdNg9BgOrnmSfNr9onItDvDCPTujB7H+EAEQ==
X-Received: by 2002:a17:902:d20f:: with SMTP id t15mr16680786ply.55.1581391531946;
        Mon, 10 Feb 2020 19:25:31 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q28sm1856253pfl.153.2020.02.10.19.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 19:25:31 -0800 (PST)
Subject: Re: Kernel BUG when registering the ring
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org,
        Avi Kivity <avi@scylladb.com>
References: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6c32ccd9-6d00-5c57-48cc-25fd4f48d5e7@kernel.dk>
Date:   Mon, 10 Feb 2020 20:25:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zZ7OFgqp88HrpKt4sW10AzjasaPkKSM7Gv68TiJt_3RxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/20 6:22 PM, Glauber Costa wrote:
> Hello my dear io_uring friends
> 
> Today I tried to run my tests on a different, more powerful hardware
> (70+ Hyperthreads) and it crashed on creating the ring.
> 
> I don't recall anything fancy in my code for creating the ring -
> except maybe that I size the cq ring differently than the sq ring.
> 
> The backtrace attached leads me to believe that we just accessed a
> null struct somewhere

Yeah, but it's in the alloc code, it's not in io-wq/io_uring.
Here's where it is crashing:

struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
{
	[...]
	for_each_node(node) {
		struct io_wqe *wqe;

		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, node);

I guess the node isn't online, and that's why it's crashing. Try the
below for starters, it should get it going.


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 182aa17dc2ca..3898165baccb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1115,8 +1116,11 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
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

-- 
Jens Axboe

