Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E540A56714C
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 16:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiGEOi4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 10:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGEOiz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 10:38:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D6B638B
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 07:38:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so2606863pjr.4
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 07:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Q05lE2V688eTokD1uLJf20CauPXRoaPakBlNtDQoQC0=;
        b=ji98tWvYYdLZ4HrmiCIhYhqLhoQ8mbphm3yNt/PKPz7E7DuedtKuCinMhUAtA1nSuD
         sSA8Hf2gOc6E0CXnnUGmQZj9WGpRNkELAioeAib0C11LAjcNUoF40TAJB8If9AAz2qGg
         PVzLLr2bUS+0OleE3NMigJH+NMHgvR0sZukVg+m0SnNkhiOJQfYjTVrpgzHsAl15cyNG
         /T2xD/RmnbiED5t/Q8/tpEowJVe4ELwZ6YMB4P4W40pGcSnbLPGyNSxjjcC1+iXKGSpl
         rdFADB2nKEdA/QsUbJ+iHK8CSHVJh8jVOgCpZ3UgwB2fNzJkb9WbUV39fHtWg9ciUdt4
         Nncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Q05lE2V688eTokD1uLJf20CauPXRoaPakBlNtDQoQC0=;
        b=LmnkaqTJT0iuuRFDkJe5msYBPbCzzo5uHpxhQyrFacNEhGUd3+4A+63SZRgRh5dRBU
         X7J7l/VdQg3x5SOj2871Gt6CO5MePzT2Ej4H/tZrufQFf4dcdW9/MME9FzpXqYzuIN+T
         Dt7OvILX9DePNCQueMSXMAarKvGcr7Ac7JXriA+h/R34v9TdF3uqkLvqBNa1VE7JFyf4
         v2fWR0YwiZ3HbsxUaYW5VA/RIb8sKa7PAmDwc4wm7YJiTcAbS8s1r+cQG9xJ7Jd3xnch
         adCZ38k+Ue8/813PmAnVHdgDiH/2ZK0IKEgeHYTLQNAP5Z07XNUWC7sEQXV0vtTa3rUV
         Kl/A==
X-Gm-Message-State: AJIora/lls0FFOLfHg+Gg9HYCZJjHelzSKN8Tq9W8c/DeLELrzI5tOoE
        WQDelsOxqPOyel71ECmESszPP91aj0Ljlg==
X-Google-Smtp-Source: AGRyM1ttxkNqrrd4ScrgyKH+ArXZix10XkBoxcRPF3aqo5ZEEBRVsZHEuwT9hF4cQarLtDcAUzEbmA==
X-Received: by 2002:a17:90b:4b09:b0:1ef:7977:9cc7 with SMTP id lx9-20020a17090b4b0900b001ef79779cc7mr20197821pjb.195.1657031932922;
        Tue, 05 Jul 2022 07:38:52 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 200-20020a6214d1000000b00524f29903e0sm22923536pfu.56.2022.07.05.07.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 07:38:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, dylany@fb.com
Cc:     asml.silence@gmail.com
In-Reply-To: <20220704160614.1033371-1-dylany@fb.com>
References: <20220704160614.1033371-1-dylany@fb.com>
Subject: Re: [PATCH liburing] fix test_buf_select_pipe on older kernels
Message-Id: <165703193212.1923002.16912315651116000163.b4-ty@kernel.dk>
Date:   Tue, 05 Jul 2022 08:38:52 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 4 Jul 2022 09:06:14 -0700, Dylan Yudaken wrote:
> timing issues might cause out of order completes on older kernels,
> especially regarding selecting a buffer before queueing up IO (as it can
> complete with ENOBUFS being queued).
> Theres no reason to test ENOBUFS for this problem, so remove those checks.
> 
> 

Applied, thanks!

[1/1] fix test_buf_select_pipe on older kernels
      commit: 7e9db7fa5fc06c3f396e244e4863938e648bcb2d

Best regards,
-- 
Jens Axboe


