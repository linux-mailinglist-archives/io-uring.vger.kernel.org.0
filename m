Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47B4277ADF
	for <lists+io-uring@lfdr.de>; Thu, 24 Sep 2020 22:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIXU7f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Sep 2020 16:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXU7f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Sep 2020 16:59:35 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C7AC0613CE
        for <io-uring@vger.kernel.org>; Thu, 24 Sep 2020 13:59:35 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w7so689304pfi.4
        for <io-uring@vger.kernel.org>; Thu, 24 Sep 2020 13:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YwvvY7s8AldcyyLQ+v6xhvCjfiFEaGCs9gT+2HoU68g=;
        b=l60jeCH1HAdUF4JMtHvNQhgTdHpRmPCWdJWQS91rAzLERZTNfcTweAyplnmOABxAHf
         ZxN6K/7CIlghX9NIOBiaVabiXgGCimJj7ZtMf+0v9KqU24nFwjlp022n9uqU6V4aJN9n
         c7ucofzoAu0aIv+6avsKK/mKb55PD/wpGtX0fQjUaw9ZWf5voUEXk4rTfoBF/FfBKKVM
         B1jFSSC5WS/VNKFmHVHp5cNy5zl/+Zsnf/x06qusfZ9Z8YakGorxoBBaGyXGD3cwqYn+
         WpzXgh/rhDbk1fQGmxiFO8kJWpi7fc2O/VpQN5X/jhWI2NSeQBvjgdYimc4Meg+6bLy8
         uC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YwvvY7s8AldcyyLQ+v6xhvCjfiFEaGCs9gT+2HoU68g=;
        b=h2x96+FzwOZb3KvHTn04d347FqDXIAjfn74DvPm17Qww3rb6ZTUlDnQDHH8UTfJCpc
         eUaz2VWI7BsitPnpj/EiaKb2fg79YsXtbEnl8yGey92aPp/ORPtYXAvgyHdJ2ltyYe7g
         fStmlUbBvq1ksA5EPrBYBpfuovgC/AeMtS2lwSmP1yXmWI0Z1yhKustcSP1KgR0M1rrz
         SrNnZOlwb9ui46/toHuInmyWzERk1MCU0dnsFiHR0Cz9bhChZJDrvScWiSubWl2OgFmh
         NLI6QWhB+M2y2jlApIXXsWd4SiEJoTn4SO8sCC68BDNKD7+E19GNzw4HIclrzPhc9Urp
         3kgw==
X-Gm-Message-State: AOAM531mQApisu/llirJzVtjl55h0WlWL9WCQVL5gkO18H3XQvTWhVUf
        aWOgXOl5VqJhaomzF/SjeWf/iQ6oviP0KA==
X-Google-Smtp-Source: ABdhPJxknHIAEFfur3P+iHA3S0GclTOy1TTlEJkf9TgGOm7JESQVF8730M6lvDeYG7eRIGQghtsx/A==
X-Received: by 2002:a17:902:8e83:b029:d2:41d3:94e9 with SMTP id bg3-20020a1709028e83b02900d241d394e9mr940769plb.75.1600981174957;
        Thu, 24 Sep 2020 13:59:34 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::1911? ([2620:10d:c090:400::5:d63d])
        by smtp.gmail.com with ESMTPSA id a3sm338536pfl.213.2020.09.24.13.59.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 13:59:34 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure open/openat2 name is cleaned on cancelation
Message-ID: <ea883f39-0da5-fcd3-a069-43d7f5002380@kernel.dk>
Date:   Thu, 24 Sep 2020 14:59:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring: ensure open/openat2 name is cleaned on cancelation

If we cancel these requests, we'll leak the memory associated with the
filename. Add them to the table of ops that need cleaning, if
REQ_F_NEED_CLEANUP is set.

Cc: stable@vger.kernel.org # v5.6+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

--

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e6004b92e553..0ab16df31288 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5671,6 +5671,11 @@ static void __io_clean_op(struct io_kiocb *req)
 			io_put_file(req, req->splice.file_in,
 				    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
 			break;
+		case IORING_OP_OPENAT:
+		case IORING_OP_OPENAT2:
+			if (req->open.filename)
+				putname(req->open.filename);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}

-- 
Jens Axboe

