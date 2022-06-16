Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8153454E5C3
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 17:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiFPPOP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 11:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbiFPPOO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 11:14:14 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660891FCC5
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 08:14:13 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id b138so1762616iof.13
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 08:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=xFjqAdSdVFnOSCBwXJGaJU8fzZPZ96JjSsOavGzAxlM=;
        b=0kXX73j6FBt9jmgXpgu7CifL6sEdAJjc3gv6BqDyni+f5UZRae3O+1uJTvshc8Bdnw
         n999/2gNOy1RpkWA39OVL2Zx1NfOlpumR6eQqsHGh/fhUNdZjBQG+gmnA2f4mlnq/ANh
         zDAkQfCgxbfWuuCNCojNgAaiOqr3qgEuKm5aOS5y2FhW2ZrhPbFltWSsi059K3n+1cxe
         UI4x85O/W+EVXJmDYQqdVVZu5qPCphlvikUlsNhupQjXjaHIvxJ3tOK96LlwSJ+qd+NB
         De9vsDS6LWH3XMOIcUweP1NDKDt5hZ30tbljZ5PhWS/3moIabKFP1xJObJu0uu4O1dZ3
         BU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=xFjqAdSdVFnOSCBwXJGaJU8fzZPZ96JjSsOavGzAxlM=;
        b=Le0CaCcfLpsc82+qLLcSuEuWR2vs8kdz1yNznTmgfeQ0V9dKrYMXatuM74CKEpNjap
         bJyaVpqUOzNo/KQC7BZRGSRotCfLYkelke7N+pnSCU84jATcnWVhZ/9RNspa1tTrSlpr
         D0BLE3ymeUjAy/oETQZ+sILPhPGKG1rmt69B/IMVgGYbr4NZbAAHcT2KKoG8svTwS2K1
         h1ebkF6aGsTct04y2nPkFL+gxUYMD6sneeYsS04VpyNYjp/VIJF06KILokAPMF1PUf0I
         gwzxreX/rtnIdb3W7YPdlsmb+6kAKdUo9Ad3d0I8GQSgGjYlfPYdhDPIeoPBHNbWXLiN
         41mQ==
X-Gm-Message-State: AJIora+V7p4UOjEI7wNEaM839fgDjSA4LmgdQX91jBf1yCX/E40Pn43v
        aJyOR/PpyDbDfhcTwBisoDjNpQ==
X-Google-Smtp-Source: AGRyM1tUB+XgGTCCsVlwWeBMalVcsjsBnvM5XsUNy+mKpZXaBjqLvrgQCKf4d7KMp1y60D991A2aMg==
X-Received: by 2002:a05:6638:1214:b0:333:e6c5:2311 with SMTP id n20-20020a056638121400b00333e6c52311mr2869862jas.155.1655392452759;
        Thu, 16 Jun 2022 08:14:12 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x20-20020a056638027400b00331c1e117absm989578jaq.29.2022.06.16.08.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 08:14:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org, dylany@fb.com
Cc:     Kernel-team@fb.com
In-Reply-To: <20220616135011.441980-1-dylany@fb.com>
References: <20220616135011.441980-1-dylany@fb.com>
Subject: Re: [PATCH 5.19] io_uring: do not use prio task_work_add in uring_cmd
Message-Id: <165539245211.4782.5397802277813950857.b4-ty@kernel.dk>
Date:   Thu, 16 Jun 2022 09:14:12 -0600
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

On Thu, 16 Jun 2022 06:50:11 -0700, Dylan Yudaken wrote:
> io_req_task_prio_work_add has a strict assumption that it will only be
> used with io_req_task_complete. There is a codepath that assumes this is
> the case and will not even call the completion function if it is hit.
> 
> For uring_cmd with an arbitrary completion function change the call to the
> correct non-priority version.
> 
> [...]

Applied, thanks!

[1/1] io_uring: do not use prio task_work_add in uring_cmd
      commit: 32fc810b364f3dd30930c594e461ffa1761fef39

Best regards,
-- 
Jens Axboe


