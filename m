Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E289417617
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 15:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345009AbhIXNnv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 09:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344913AbhIXNnr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 09:43:47 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE80C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 06:42:10 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e82so12528408iof.5
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 06:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wWH4zFazvadEkFRkjmRQ4C8hhodfey2njbHYNPUDJnk=;
        b=Jxu+qjCWq+K4+ofwvgd3x5T/JVC4Z6lde95jD/e1gwSh0O/P7oTv7Ei9qeA50qHEzv
         WvSVmfhYpOXiRmSJ9jrBbZknDGShRZr1layaWRlBFqqSPyi5pqtqCGSVq3LYpB8JKoFz
         FwJxkcIlN4vA31y7vWPqVNxuSv7kApSgJmgx4ig9NtNkckl5vSkt2tv3lM+kWjKYWTrH
         lYuQx9eYA7M6WjBkaEmtAWpkePmPVpb0evyNOYpfw1I6hgcLxDGwPKfl/3VDXkgmLKbe
         IhWVGIyIn3KFgFANYGIGNnSkFJcZUpygnd35yXk4aFcqQHT7wsmUS81PMYrRHPFa545E
         hQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wWH4zFazvadEkFRkjmRQ4C8hhodfey2njbHYNPUDJnk=;
        b=miGqoo96I89TslGgOBvhb+j+1vn6+K4OALj6fXQ0ROVqVK5B0dIvKy5idZQ5/gJluJ
         8y2cPPkhnY0K+TdnHnwjMf5UleHIZi5kxmyJrl78Z6I6mitskQ2cby4oPeefS89rKqsO
         Pl2Xd6RYBaxR0cJ/zYMkvFwzZ0I8QI1RZDgLy/jr9ymHufUyD7Ccmy1quyS9dwFPlshW
         8XH2B3Av9mGp8mshy4MoH0oSNMuHKWPlLb+ykdTBLMtPt5hIafoiTJtvYvgaLX4bdnYK
         M8d/XZdanzryjpRI+n7QvCrLJVtLO+xObVrm9CKwSR9rh16fLPd0f8HAHsLLYa1cyUDh
         CRvw==
X-Gm-Message-State: AOAM531D0pp4f0xN+lnTXPsCFjtvr32AFSpwT+Us7U8igVZywjyPksgw
        WUjJsVDX4FlAOhQpgNCd27PQrkalhPymloLSX48=
X-Google-Smtp-Source: ABdhPJxqA7KhwIfnLwz9yUwz/aENxcHnUCX5QB7Ng8e/hn0m8Q4vBQFbahVEGzmvOoKYKB1mM2GBqw==
X-Received: by 2002:a6b:5913:: with SMTP id n19mr8796251iob.91.1632490929858;
        Fri, 24 Sep 2021 06:42:09 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b3sm4242818ile.37.2021.09.24.06.42.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 06:42:09 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: put provided buffer meta data under memcg
 accounting
Message-ID: <94028707-1f2f-73b8-aaec-b606dbbc908e@kernel.dk>
Date:   Fri, 24 Sep 2021 07:42:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For each provided buffer, we allocate a struct io_buffer to hold the
data associated with it. As a large number of buffers can be provided,
account that data with memcg.

Fixes: ddf0322db79c ("io_uring: add IORING_OP_PROVIDE_BUFFERS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 056418f67ef6..67a6f5666965 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4351,7 +4351,7 @@ static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
 	int i, bid = pbuf->bid;
 
 	for (i = 0; i < pbuf->nbufs; i++) {
-		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
 		if (!buf)
 			break;
 
-- 
Jens Axboe

