Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5325E6E6967
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 18:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjDRQZ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 12:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjDRQZX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 12:25:23 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A177DBB8A;
        Tue, 18 Apr 2023 09:25:11 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f40b891420so2592006f8f.0;
        Tue, 18 Apr 2023 09:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681835110; x=1684427110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tkrQvmuaMHpjbiE++zr5BVroiXJ7ScDCYIMg0fujBHo=;
        b=SiZWAmYo56/FBTixK5uRz3YVCkB21wCREmr1czchs+GmA+dvmsS1O2PL0ur8egLMXe
         G3NbOGUT6dObEj1Zi33dWKNM0xdCHyo3v2mIdHaBhuHttqrYmu/Ca3V4S/WO11vJA3Zk
         jwoJgTDOjMZtjNy1gPTK5S5ZaSYDbRznJFNiPE3Ryzw6s9A+s0pc6VWN7mhQ7NNMKeEq
         QPqevBvbQ+huF9KOhwCkBZmZtZK/CHtbDa0ynZmKXhlRJpfVwG0XsVT8yA7Ejbn8ND1N
         7iPi2FHFCVv9sRLnSh5+3VodoGnw2BZXUWntQUCCaqErsqVlEkdgqrENwtsk291wvN+q
         bYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681835110; x=1684427110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tkrQvmuaMHpjbiE++zr5BVroiXJ7ScDCYIMg0fujBHo=;
        b=Rdp8ZVeoHYnis30rB7dckW1hl9o9xrsmvO/Rxoxk6J/sfDYoCK2KZ+ZEopX2AvE9AR
         GGIOo3Bdd14XvSmbYzsV+/ZXcNkdsFiGCrlUZa10sxv6dsMj83zHr1O6wVyPCHSg6grf
         sQFNNxCHUe+TViJsvU5ijvl3yEvnoIzfYLrZDdM+qBFggpR7JTMw82hWkrOK+PK66DuH
         Z1FVDc5n5PsAOaiOZq/G52wDV6QuVk1wI+B65x/PnbqJ7BbhllZUCQNKlQt/SImcAyw8
         Mlv0yj9G2Vuo80dDcCy5RnReaF780456ZzEyCu2kd47w69YW5p2VGB+Hr1HFM5tsbQ9O
         pjwA==
X-Gm-Message-State: AAQBX9fDuCL/pKEzrwBYpm/PLREcIFV6gT7xwNpvz9ZBlanBDABqem/f
        /MOA50PFVMYkT5JW/WPgZ38my3h1A0mKcw==
X-Google-Smtp-Source: AKy350Ye3wY8Ve3DZ7sGgIjHgWrlClaJ5M4kd1rL+JaDBP63tIs8tkec5hOaQONG71C1PTxydnnEig==
X-Received: by 2002:a05:6000:3:b0:2ce:9cc8:34db with SMTP id h3-20020a056000000300b002ce9cc834dbmr2264248wrx.71.1681835109924;
        Tue, 18 Apr 2023 09:25:09 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id o9-20020a5d62c9000000b002fa67f77c16sm5694266wrv.57.2023.04.18.09.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 09:25:08 -0700 (PDT)
Date:   Tue, 18 Apr 2023 17:25:08 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <7950398c-1993-4006-9af9-8e924ddb2dda@lucifer.local>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <7fabe6ee-ba8f-6c48-c9f7-90982e2e258c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fabe6ee-ba8f-6c48-c9f7-90982e2e258c@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 18, 2023 at 05:55:48PM +0200, David Hildenbrand wrote:
> On 18.04.23 17:49, Lorenzo Stoakes wrote:
> > We are shortly to remove pin_user_pages(), and instead perform the required
> > VMA checks ourselves. In most cases there will be a single VMA so this
> > should caues no undue impact on an already slow path.
> > 
> > Doing this eliminates the one instance of vmas being used by
> > pin_user_pages().
> > 
> > Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > ---
> >   io_uring/rsrc.c | 55 ++++++++++++++++++++++++++++---------------------
> >   1 file changed, 31 insertions(+), 24 deletions(-)
> > 
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 7a43aed8e395..3a927df9d913 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -1138,12 +1138,37 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
> >   	return ret;
> >   }
> > +static int check_vmas_locked(unsigned long addr, unsigned long len)
> 
> TBH, the whole "_locked" suffix is a bit confusing.
> 
> I was wondering why you'd want to check whether the VMAs are locked ...
>

Yeah it's annoying partly because GUP itself is super inconsistent about
it. Idea is to try to indicate that you need to hold mmap_lock
obviously... let's drop _locked then since we're inconsistent with it anyway.

> > +{
> > +	struct file *file;
> > +	VMA_ITERATOR(vmi, current->mm, addr);
> > +	struct vm_area_struct *vma = vma_next(&vmi);
> > +	unsigned long end = addr + len;
> > +
> > +	if (WARN_ON_ONCE(!vma))
> > +		return -EINVAL;
> > +
> > +	file = vma->vm_file;
> > +	if (file && !is_file_hugepages(file))
> > +		return -EOPNOTSUPP;
> 
> You'd now be rejecting vma_is_shmem() here, no?
>

Good spot, I guess I was confused that io_uring would actually want to do
that... not sure who'd want to actually mapping some shmem for this
purpose!

I'll update to make it match the existing code.

> 
> -- 
> Thanks,
> 
> David / dhildenb
> 

To avoid spam, here's a -fix patch for both:-

----8<----
From 62838d66ee01e631c7c8aa3848b6892d1478c5b6 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lstoakes@gmail.com>
Date: Tue, 18 Apr 2023 17:11:01 +0100
Subject: [PATCH] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()

Rename function to avoid confusion and correct shmem check as suggested by
David.
---
 io_uring/rsrc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3a927df9d913..483b975e31b3 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1138,7 +1138,7 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }

-static int check_vmas_locked(unsigned long addr, unsigned long len)
+static int check_vmas_compatible(unsigned long addr, unsigned long len)
 {
 	struct file *file;
 	VMA_ITERATOR(vmi, current->mm, addr);
@@ -1149,15 +1149,16 @@ static int check_vmas_locked(unsigned long addr, unsigned long len)
 		return -EINVAL;

 	file = vma->vm_file;
-	if (file && !is_file_hugepages(file))
-		return -EOPNOTSUPP;

 	/* don't support file backed memory */
 	for_each_vma_range(vmi, vma, end) {
 		if (vma->vm_file != file)
 			return -EINVAL;

-		if (file && !vma_is_shmem(vma))
+		if (!file)
+			continue;
+
+		if (!vma_is_shmem(vma) && !is_file_hugepages(file))
 			return -EOPNOTSUPP;
 	}

@@ -1185,7 +1186,7 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 			      pages, NULL);

 	if (pret == nr_pages) {
-		ret = check_vmas_locked(ubuf, len);
+		ret = check_vmas_compatible(ubuf, len);
 		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
--
2.40.0
