Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EAC772DD1
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 20:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjHGSZD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Aug 2023 14:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjHGSZC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Aug 2023 14:25:02 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490F6FD
        for <io-uring@vger.kernel.org>; Mon,  7 Aug 2023 11:25:01 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bb91c20602so10145835ad.0
        for <io-uring@vger.kernel.org>; Mon, 07 Aug 2023 11:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691432700; x=1692037500;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pJjNXs4QCJ//eacbs196+Ii1BpskstaQNpYfpqnv34=;
        b=ECfFRsZ2TmUZ7htazz0ADil5U+61AGiWM+GoiW6Lhiam7R+EDSz9/IZU5lx6UkBmkx
         Qc9dmGEtWhGxNP0ZAldLyp1x8obSsZc/Qr3SypuwsECYFRu4y4Ec9ZtbqZzBOysE3omh
         /uT9PtGi1pZA3mAjarA7du7RldOMaQ/DURy9bPAV+4h7gi/6bUpnlJoZxU5nf+Dg8mrM
         52b4Oymvh2snCdPlCOOVJ5WWobsK9B6JB80D33gdnjBiu2ON7jixW8Ndy7oDAL1+zbeC
         wvu5cPfykg/vCBfP5C1s6/REbGSA+tBv5bBGXiO8uEfrfAr0m+VJ46Vuh9HlN9e2/hts
         mi4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691432700; x=1692037500;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pJjNXs4QCJ//eacbs196+Ii1BpskstaQNpYfpqnv34=;
        b=iE/xNVAwWF+wjDCvVSRvBbNMdFBkju25pXmL8gEkqkcYe7izZQ4jwEYQ2XhUvOq+g7
         hl+norF74x0fJnRLpFANoF9qgEUKEjcOx0O3ttSYHttfq86rBxWe/ImK/uU2a8LHvzNg
         fRcV0ykyFEf2OzkDOasRJ8unezTDgZGyDUS/EU4868dSIp2zQEICyZbEO7zZM/FirO0x
         uJWASxuBqoxJlDI7gs4ZgizGBEo44Dpe2YIhtVf6tqVv/OnNYBd9gLcNztqh3SGhHDoO
         v8fTB3L+PI7EWRmFJYvC6UN0uMA5qe2luV75VhYlLlLdpJ1AcZLrOExnGGmd4NyYjLg8
         Wt9w==
X-Gm-Message-State: ABy/qLZCpw8gFAjbjMXrydz0Y7yj0TVczT4vFBafKNYuKjp2QocK8cpt
        irNgDTdy7dndnlp3aesGlsey4Q==
X-Google-Smtp-Source: APBJJlFURYryyRLRBjK4Cyr916nSBSaubf5aUgZlsfvmwJhugTUqlPYOfhCnpbjWJ4qrDtXrk7/lgg==
X-Received: by 2002:a17:902:d503:b0:1bb:83ec:832 with SMTP id b3-20020a170902d50300b001bb83ec0832mr33892430plg.2.1691432700593;
        Mon, 07 Aug 2023 11:25:00 -0700 (PDT)
Received: from [127.0.0.1] ([12.221.160.50])
        by smtp.gmail.com with ESMTPSA id u3-20020a170902b28300b001b66a71a4a0sm7240722plr.32.2023.08.07.11.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 11:24:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Aleksa Sarai <cyphar@cyphar.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20230807-resolve_cached-o_tmpfile-v3-1-e49323e1ef6f@cyphar.com>
References: <20230807-resolve_cached-o_tmpfile-v3-1-e49323e1ef6f@cyphar.com>
Subject: Re: [PATCH v3] io_uring: correct check for O_TMPFILE
Message-Id: <169143269944.27533.6390760474967259170.b4-ty@kernel.dk>
Date:   Mon, 07 Aug 2023 12:24:59 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 07 Aug 2023 12:24:15 +1000, Aleksa Sarai wrote:
> O_TMPFILE is actually __O_TMPFILE|O_DIRECTORY. This means that the old
> check for whether RESOLVE_CACHED can be used would incorrectly think
> that O_DIRECTORY could not be used with RESOLVE_CACHED.
> 
> 

Applied, thanks!

[1/1] io_uring: correct check for O_TMPFILE
      (no commit info)

Best regards,
-- 
Jens Axboe



