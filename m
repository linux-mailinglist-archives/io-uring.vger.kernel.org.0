Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836A556889A
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 14:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiGFMpf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jul 2022 08:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiGFMp2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jul 2022 08:45:28 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B30426118
        for <io-uring@vger.kernel.org>; Wed,  6 Jul 2022 05:45:17 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p9so3415151plr.11
        for <io-uring@vger.kernel.org>; Wed, 06 Jul 2022 05:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=FeiCsYPIN96XdYKMvXDXDT0ln02u3VBSNGoRgLS0aXg=;
        b=wO8KdIxj8BhygH26JWcwBDCOiy4+uNJIyuvv6Xs9uWNYCJsvUfEvxi97hrtXBjuSBn
         WewSY18fvlbXFMY04HUT+ewiDaIKdIqw0mFg2n+D+mKLuRBLrd/gmuQvZVbd7k9xwxR9
         C+do7G767/nJZsirLg1ZIur0Yd3e/p6vaaA3UFtW4LWqRe92P3iSCOcawDKTwvlSllCm
         ZQl1uZ3f7RcExvzXOabWeBkcw+L+Kr3oNemxCXfO9q9wDp2MFS48haZ/+CdJxXPhuaRT
         VYPXoYG4A1BMfLPGaad4aGka834vv5+0WY/u2EwfjJDrw4W4kkNaVAZGWYG/zrUdAJw9
         yJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=FeiCsYPIN96XdYKMvXDXDT0ln02u3VBSNGoRgLS0aXg=;
        b=ECfE2ifUyzQ3YloFWuisXJRosodrMoODiO8FQoVMuVWJ80F4E4eii0QTjbo79MLOeb
         30gnSYqO78ueg/kUTyCAoIebxSfiK8V4ulw2ewY63HEC+Gp0Y35PsusuhRkCDzaunPmN
         YIIznF6NK524tbSzqK+gEETnUYuRDTyOmaCJxS36T5VoQ5SyO1iAm9bGMjCO3/e8yaMI
         du2I/hxXtBdUIdyfPo+Wt2HjbMhVq2TwjJqvgFZKgmIO9QNY8urO4BVGxQXlBda3QX4Q
         Y5+xGUKgKflYDJyFxMZqL8RA5Gg7IdVdjoTn82/ht2fcnqh2iCmtGJ4RVrFFVINj9Bls
         +H1w==
X-Gm-Message-State: AJIora9PDWFfMwefSICVbqWoAlSwNrDquCns4FR6JfcVDKRP+DtBjl9C
        3xEydRRG1DHNLJ/2Gmppd4uh66gUwhv2Rw==
X-Google-Smtp-Source: AGRyM1tt3x6k/9iiiv0ZQz9wgGpCSFfaQZ7b5YnL7/7+iC5j/PmzQHcGKEQQ9zb3uaSy14913sGUiQ==
X-Received: by 2002:a17:90b:1e45:b0:1ed:2fae:bc5a with SMTP id pi5-20020a17090b1e4500b001ed2faebc5amr50231670pjb.208.1657111516978;
        Wed, 06 Jul 2022 05:45:16 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n16-20020a170903111000b0016bdd124d46sm7758725plh.288.2022.07.06.05.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 05:45:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     eschwartz93@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <20220706034059.2817423-1-eschwartz93@gmail.com>
References: <20220706034059.2817423-1-eschwartz93@gmail.com>
Subject: Re: [PATCH liburing 0/6] More wor on updating exit codes to use
Message-Id: <165711151626.294829.6761581197529682758.b4-ty@kernel.dk>
Date:   Wed, 06 Jul 2022 06:45:16 -0600
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

On Tue, 5 Jul 2022 23:40:52 -0400, Eli Schwartz wrote:
> Eli Schwartz (6):
>   tests: do not report an error message when return ret that might be a
>     skip
>   tests: handle some skips that used a goto to enter cleanup
>   tests: more work on updating exit codes to use enum-based status
>     reporting
>   tests: mention in a status message that this is a skip
>   tests: migrate a skip that used a goto to enter cleanup
>   tests: correctly exit with failure in a looped test
> 
> [...]

Applied, thanks!

[1/6] tests: do not report an error message when return ret that might be a skip
      commit: 6165251b85b6d431a7e2aea2c74e8a96f2ee6fbc
[2/6] tests: handle some skips that used a goto to enter cleanup
      commit: 32dee00eac664d4e59431fdbdb86301ed742feda
[3/6] tests: more work on updating exit codes to use enum-based status reporting
      commit: f955f102a9e62ee1b4c1b0eb9163f35433b85063
[4/6] tests: mention in a status message that this is a skip
      commit: 8780732115ece2d0a687df9d825bd0e8dd9e8643
[5/6] tests: migrate a skip that used a goto to enter cleanup
      commit: 80677160b2e634714412ba79d0faed326d29ae4d
[6/6] tests: correctly exit with failure in a looped test
      commit: 5d0e33f50a06db768b1891972daab40732400778

Best regards,
-- 
Jens Axboe


