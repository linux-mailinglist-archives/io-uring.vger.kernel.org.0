Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A551C510C59
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 00:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243859AbiDZXBq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 19:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346075AbiDZXBp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 19:01:45 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C6466206
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 15:58:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id t13so106207pfg.2
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 15:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=VsZTkYBDAVKt9NvM53yZwr1vvVFb7lg5gLMBYeVrZfI=;
        b=PBmJeextCz4u0h5ot8v+I+0BvmisD7c7SNhVQmq43Kgnr/cvLiPTblrftl4cRTTno0
         rxI39CeSVhtUz7jYm7H9Xy3yjg7aDCbKRiWWUolrnPgHARDrlkVu4asvAjBKzESdDGzl
         7+SQvaHl3sZ12IC6a2ZqdphdZoXuzFFyP7OyZBNUvc4DEo1vAPZiBr/QFPiCZE9rPIxr
         oDtUIOuPqhfzCNGPDfOWMEG9iGeTeKjqmSheF/TSx32JtKfZH2CBqP2HPfbxGT013M2T
         jFEexfOwvNFeS1NhUx7QgijzDUQtTFGqpXfk8KkSMGeO/l+EOWGrx/Fmx8e7ESio1kaj
         uP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=VsZTkYBDAVKt9NvM53yZwr1vvVFb7lg5gLMBYeVrZfI=;
        b=GkzyKk7Pay+8enRxtKV2chHEEFIViYKZBFjLFWy+hIzQjIzWe8of5BPv7QBKdHfvtu
         h+PWiDc9ZllBav/hQzQtb7jcNpjw5PQhPsw7E4mU/4QROKwnBNw3UJWk0Pc9zMChQejO
         RjuYazqC4KeXCjsDVwvOKs9FqAXMiwZmxRCCTJUSq5zrL2Mz4MUTSnjTkbbz5zaPKLVB
         qKMy1ac+JR4JqlVrR/+ouP8TDbEZa/quzSo0bxh9BVTf8IfUoVYKUhULCmbxHdYWBvVF
         Yw+DuKUb8obBFXQOdpwpM7e8Ibfpxx9Mbyg6w+F4R2yljRz0yeUpQ+EZ4jEjeoN/lc2J
         NYxg==
X-Gm-Message-State: AOAM532ayIHkX7FjaXPHVszp9l6LO9v707RzR6Oj5ib4Xee5+0aKCiUN
        w0W/dD3gylX5y+8kwluMYNf0hmE2HrUbyoHE
X-Google-Smtp-Source: ABdhPJzQD9b/3DUGAcmR/GBQ2L5JCE7nnad8t/eXE8G7QGXJI91ISwRDB9gErP86URA/6sif5ECnaA==
X-Received: by 2002:a05:6a00:1506:b0:50a:754e:5d4c with SMTP id q6-20020a056a00150600b0050a754e5d4cmr26829801pfu.37.1651013915603;
        Tue, 26 Apr 2022 15:58:35 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s10-20020a63e80a000000b0039e5c888996sm14032559pgh.86.2022.04.26.15.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 15:58:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, shr@fb.com,
        linux-nvme@lists.infradead.org, kernel-team@fb.com
Cc:     joshi.k@samsung.com
In-Reply-To: <20220426182134.136504-1-shr@fb.com>
References: <20220426182134.136504-1-shr@fb.com>
Subject: Re: [PATCH v4 00/12] add large CQE support for io-uring
Message-Id: <165101391469.210637.11826028295180623775.b4-ty@kernel.dk>
Date:   Tue, 26 Apr 2022 16:58:34 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 26 Apr 2022 11:21:22 -0700, Stefan Roesch wrote:
> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
> To support the longer CQE's the allocation part is changed and when the CQE is
> accessed.
> 
> The allocation of the large CQE's is twice as big, so the allocation size is
> doubled. The ring size calculation needs to take this into account.
> 
> [...]

Applied, thanks!

[01/12] io_uring: support CQE32 in io_uring_cqe
        commit: 5c8bcc8e97123e3e68a6b1aa4c3eb6c5d5b9d174
[02/12] io_uring: store add. return values for CQE32
        commit: 04c3f8c8deae29e184d54b2cd815f39fd46c6b2e
[03/12] io_uring: change ring size calculation for CQE32
        commit: 9291ac41fda10ba7e80fc2147ca39a3b1d130ef9
[04/12] io_uring: add CQE32 setup processing
        commit: bc6bda624e953fcf42c6075fe35a219ce6df4bc4
[05/12] io_uring: add CQE32 completion processing
        commit: 22b76e8c5fd312701a1827b970230ee66aa24f69
[06/12] io_uring: modify io_get_cqe for CQE32
        commit: 771c7f07faf909b9993fd5e42581c8c82531fb58
[07/12] io_uring: flush completions for CQE32
        commit: b8e5029ed965c01066009bcb172c082b60ff436c
[08/12] io_uring: overflow processing for CQE32
        commit: 3ee1cd786a668ba2a6e8dfefacb8f29e1d995c12
[09/12] io_uring: add tracing for additional CQE32 fields
        commit: 225afd24978b55a771660fb4c6ad90cac75e7da8
[10/12] io_uring: support CQE32 in /proc info
        commit: 41a971975a3ae2b498b9f5ecad34c34280f0ffdc
[11/12] io_uring: enable CQE32
        commit: bb30aab40bcb6e9b80321615a2847a9491c95bf9
[12/12] io_uring: support CQE32 for nop operation
        commit: 0fde61fe729221b43d9c8374cb57e571f4fb2a16

Best regards,
-- 
Jens Axboe


