Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378245813B5
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 14:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiGZM7a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 08:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiGZM73 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 08:59:29 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CDA255B5
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:59:28 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id li4so2035248pjb.3
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=DrbYxdpvfuDhP0ehLAs90VoZ6/TyxfaeIwxXS3Tutp0=;
        b=fZJQXaOYmiaIwWeIOH6GvkEWOFKAE2y+8KIoKLcozYIuhKsM35kp6Mi1SKOhjezr/s
         NpenQCTuQ/RRgWLiH1EIF4qXAO+c+1Yrjn/c6Gyf56rsbGn8MuAiYnF08Mnz7rQe9Q/x
         gDM4ivxHUpFk+A5aNu5F/yvMPCPWPlr7TPFAFuVwD9YjxG4zXPEEiVE+MKN6l3Dc+6jt
         ADPPNmUQzvAXhcaN4i5vjfNxG0tDaVbkqq/MfzUhRtGl4Tv5QLNNYN1Nblyv6vLi5RaE
         geYDrOT0XL+6lM6ZhC0CgkK9BAHegNRec5Sb5hbFo58BY7XRZBpHgaZXdTmdElihHZn1
         Aq4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=DrbYxdpvfuDhP0ehLAs90VoZ6/TyxfaeIwxXS3Tutp0=;
        b=lS/h2cTvj3IxKWcc+mbSqdBA5+1xpBwX2aarVquHnUmu2bVaLl1oZvwm9wfu2qxh5G
         6QIvs+KDFtmH9Uo1lcXKBWvo30LFjoWb6VA1uaiMAWgGqhz7AjoJynxv8vviXN5JDlJj
         OE8ugS+f0BkAVJqL3LhisaAx+VyiPJRl1oGC8rBiEcoXAvZuTTOTfh6y7GKpMnH4Rv6C
         hcthsBHL0PiVvR+xr/4KW7Jx1kN9ld3wRqSyqxWkjAfgMCuXm/VVYHY7pwAKtFSIUaBp
         RBSIpCJKemny1D8q+sQmi+ZWtumucHXDiYIufxw33AVfMry/PXYLc5n1H8DRfPeF6WFR
         aWoA==
X-Gm-Message-State: AJIora+q8fDNGJ1BHpfHCEf4IsSyQJquSkRWegfS+geOCoIrrceQkuqF
        DbKoQUgkag/i5GAjWvN5h0+Xgkt2/2BBpQ==
X-Google-Smtp-Source: AGRyM1sFylP+QCau96QSH8gIiI8bJWBTd5OEwnsF1h9nLOTCWFo/Ila06N7z5dwj5CE4z8P5ibroxA==
X-Received: by 2002:a17:903:110e:b0:16c:f81b:59d2 with SMTP id n14-20020a170903110e00b0016cf81b59d2mr16202401plh.142.1658840368050;
        Tue, 26 Jul 2022 05:59:28 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q8-20020a63d608000000b00411b3d2bcadsm10105891pgg.25.2022.07.26.05.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 05:59:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     asml.silence@gmail.com, gwml@gnuweeb.org, io-uring@vger.kernel.org
In-Reply-To: <20220726094908.226477-1-ammarfaizi2@gnuweeb.org>
References: <20220726094908.226477-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing] .gitignore: Add poll-bench and send-zerocopy examples
Message-Id: <165884036728.1504509.6256951797289184138.b4-ty@kernel.dk>
Date:   Tue, 26 Jul 2022 06:59:27 -0600
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

On Tue, 26 Jul 2022 16:49:08 +0700, Ammar Faizi wrote:
> Previous commits add poll-bench and send-zerocopy examples but forgot
> to add the compiled files to .gitignore. Add them to .gitignore to
> make "git status" clean after build.
> 
> 

Applied, thanks!

[1/1] .gitignore: Add poll-bench and send-zerocopy examples
      commit: f0f95d7296eeee9ca6b403cf68faf3b7cd59aa0b

Best regards,
-- 
Jens Axboe


