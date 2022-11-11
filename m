Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29106264CF
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 23:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiKKW7u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Nov 2022 17:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiKKW7t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Nov 2022 17:59:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564F411A3C
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 14:59:48 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id c2so5323564plz.11
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 14:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NlOaUI3wlenw4IeQRidxC7Bv1qeQ3OOSWR19UuCJAPI=;
        b=Tcd+QCY2+x1SUqoL3VU6toVU45SGG453iv93TsfNME9FZcMA8c+gZZd69MkJUEjoiK
         pp/NhQbrDMajm6tsgCUCn5E5VPf2unoMWvox1U10lFosBpskWZWl5OqKKm+1Ts75yLrO
         X7xJqzRiM8oPjqXJOBnrMt/lvY5vNaFj2r3hCeCWDEr62cmUgczI6HuMkH4EBbb1D+us
         Nt3e0SyrYlFwh5aiLO94Dm2JpYcuHfe9vBjOb2GIGLtz671jVSR4MstDpNtqDcZPuSVZ
         fwEf4eYOPWLN8AwdngAg2qdzU0xtznObqisE2YZABcIfJ2vNdugB2hTbyaH8r4vU2/bG
         /GVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NlOaUI3wlenw4IeQRidxC7Bv1qeQ3OOSWR19UuCJAPI=;
        b=hLydLPjAgQ77qTqigN6GfoggKZMKc3U73awmAr/Zc1jEdQ+4Ga/jW2KaBm+PwvElGv
         iP0gYAvecXMyN9gOZWTEuW0FBI26fOsCHrBUklbx9S9TN0BnWRbdFUSYlvflilUf8Fan
         jvvyraeID/3it7+2NReYwEl7J1kmYH6Q0xZNFG01ntXScuyCxLkM81UU7dV9LoCyoGHQ
         b9+1Awm93u274++SnH3edVDzzrxFcE9wPHLk7zX0QGkwBeluh9UxTsllnpwGRr6uCWAC
         FdGrnU8YUfg1kH81BIHUPrySvh0a4j64yb+mkHqx9dH1S4YMcw7YWo6t7tHPjxaasugw
         PNKg==
X-Gm-Message-State: ANoB5pmCB7mAPrSUjssZ0wOs6iQWg8+wmfX65eE5N/cnJ9OAJGTS2Yhn
        sH6mDlfw3EHFx+OSw3ITSHZjtIfdTwmY9Q==
X-Google-Smtp-Source: AA0mqf4r+EqEw6Se8GR8sBOXV3rPU70+X9/OqytW+zAE1xmFcZdxOQQ0Z86OT0vUFfIQQLUcFsqmng==
X-Received: by 2002:a17:902:f30c:b0:187:3030:b1c2 with SMTP id c12-20020a170902f30c00b001873030b1c2mr4272819ple.125.1668207587560;
        Fri, 11 Nov 2022 14:59:47 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g17-20020aa79f11000000b0056da2bf607csm2052888pfr.214.2022.11.11.14.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 14:59:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1668184658.git.asml.silence@gmail.com>
References: <cover.1668184658.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.1 0/2] Subject: [PATCH for-6.1 0/2] 6.1 poll patches
Message-Id: <166820758620.2555.11114813042825322072.b4-ty@kernel.dk>
Date:   Fri, 11 Nov 2022 15:59:46 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 11 Nov 2022 16:51:28 +0000, Pavel Begunkov wrote:
> 1/2 is a fix following with a small patch adding a lockdep annotation
> in one place for io_uring poll.
> 
> Pavel Begunkov (2):
>   io_uring/poll: fix double poll req->flags races
>   io_uring/poll: lockdep annote io_poll_req_insert_locked
> 
> [...]

Applied, thanks!

[1/2] io_uring/poll: fix double poll req->flags races
      commit: 30a33669fa21cd3dc7d92a00ba736358059014b7
[2/2] io_uring/poll: lockdep annote io_poll_req_insert_locked
      commit: 5576035f15dfcc6cb1cec236db40c2c0733b0ba4

Best regards,
-- 
Jens Axboe


