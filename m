Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFAA7B6DE8
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 18:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbjJCQCm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Oct 2023 12:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239189AbjJCQCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Oct 2023 12:02:41 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F95AA7
        for <io-uring@vger.kernel.org>; Tue,  3 Oct 2023 09:02:38 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-351265d0d67so1291405ab.0
        for <io-uring@vger.kernel.org>; Tue, 03 Oct 2023 09:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696348957; x=1696953757; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGVHSWA8WBzexndhf7CtPYjmGQKCJH3W0EMnIrurk+k=;
        b=0TfOoUgh9h3aV0tW/b7MUP4OciwkW8PLxe9s1sBkHjT/XwweWbY8L72+5vpCPFmD40
         2jRh2Iq1OmQEdfJy7SFet3PebWMqc6tXXGT7SOuuRXTsiquS5ikdTQBEtfGS7cIJe5cP
         68W5KlnWtYRj1MkGSV7Dps+Lmx7X3Al+RgiCCgbdZFTCiaQq270ZwFvagG/BaH7LrnB0
         t8pysaus3JWkTOLK63ErMvgK7McIS0F/og5fMkIW7m8sRIBzcG51SBO/H3l9+oG6MZzI
         cC0eD5JkJWYRUN8HRUi8CbVznBA61Kptmu2y7TDp+wZ45ZrEJkHbfED7JH5QHob48HKB
         Zo9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696348957; x=1696953757;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RGVHSWA8WBzexndhf7CtPYjmGQKCJH3W0EMnIrurk+k=;
        b=trHrazL6S8nu6/NJkqDBOdUrTkp/SpRbm5d29i26MfjwLDTcnKwoccx07i3kA634mN
         M0B1LvXu+jm4ay18bBu22a0z9LZOvdtwJZG1z/4euDX9FgcEkvChPZ4hl41Hd7TmkCPX
         JTiklx8OhTV85V0F7VE9khEySXRa16GM7pNdG9cwtNA4yg1gUirOQfOWm7zwOyCVSXiw
         tijwZFceJYsdcRhhGbE5Kp9gZahugFn/8opefvVROFO2hD1cd98HDRD5rV69A71sJeJH
         4s2nWjvQf0sId8TCtgYr1E9GHJaGGE4GFoxLzkeYilyt1AvcLDZ3r+sAw/K01hGXP+d4
         m0Qw==
X-Gm-Message-State: AOJu0YzCclW6WKQCgahvzkIWZvuP8h3NWEnNV02imbzbNnc8+pWpzFQv
        EUwp6Dl6gkK84WXHm5zbX9wY97edgJBztRm/3WU=
X-Google-Smtp-Source: AGHT+IH0KpxqrLgQQXVFZBVKbtmzTSL2voT1jW+ajwp6udZllg8n++8m0ob2Gvj74QuFweVYYLtcCQ==
X-Received: by 2002:a92:d44a:0:b0:34f:a4f0:4fc4 with SMTP id r10-20020a92d44a000000b0034fa4f04fc4mr13874518ilm.2.1696348956760;
        Tue, 03 Oct 2023 09:02:36 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fn12-20020a056638640c00b00439e3c9f958sm421928jab.129.2023.10.03.09.02.35
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 09:02:35 -0700 (PDT)
Message-ID: <4c9eddf5-75d8-44cf-9365-a0dd3d0b4c05@kernel.dk>
Date:   Tue, 3 Oct 2023 10:02:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't allow IORING_SETUP_NO_MMAP rings on highmem
 pages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On at least arm32, but presumably any arch with highmem, if the
application passes in memory that resides in highmem for the rings,
then we should fail that ring creation. We fail it with -EINVAL, which
is what kernels that don't support IORING_SETUP_NO_MMAP will do as well.

Cc: stable@vger.kernel.org
Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 783ed0fff71b..d839a80a6751 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2686,7 +2686,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 {
 	struct page **page_array;
 	unsigned int nr_pages;
-	int ret;
+	int ret, i;
 
 	*npages = 0;
 
@@ -2716,6 +2716,20 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 	 */
 	if (page_array[0] != page_array[ret - 1])
 		goto err;
+
+	/*
+	 * Can't support mapping user allocated ring memory on 32-bit archs
+	 * where it could potentially reside in highmem. Just fail those with
+	 * -EINVAL, just like we did on kernels that didn't support this
+	 * feature.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		if (PageHighMem(page_array[i])) {
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
 	*pages = page_array;
 	*npages = nr_pages;
 	return page_to_virt(page_array[0]);

-- 
Jens Axboe

