Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C475EB66A
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 02:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiI0AnU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 20:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiI0AnT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 20:43:19 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9E7A1A72
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:43:18 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c24so7726921plo.3
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=FaJyKk+R0q52iF8mEGrRWRG4smFwTQuUpqQX3bc+UYU=;
        b=DZbkf7xiFDIa6SY5NiYcAh84094KL9e9+nv8FcL8RX3+/Uxte3isWZC7p/qez6hxTI
         32MpfTdXZxXsufC5blI5+rI6nOwex2TvYQkukoZXox6axJT+pTB8IrS4rfq4GqoGb3pM
         g/0AgCMC3G2Zu1Jn877XEP1a9P6RxKL5Z9xsnqNqE/nwJQJjTSCx0+8xnyXqt2EIwR7c
         oN7ULwY87eCMCqz1Pshx6P3iojB8gQOGsp3mZ/Z8Olq9VcBRWbtH9G8mXxUcBXt1idcx
         CN577aZkyNgACeGLy99BjNBcmHCvIl4G2zCyKMZDSIc1rtY671DksdIbNWMLUJ4q0WGY
         UblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=FaJyKk+R0q52iF8mEGrRWRG4smFwTQuUpqQX3bc+UYU=;
        b=3l/6tQXFbNLttsWDuIc/H1oM0S6j9wad/OPuHr63oVC2liH70f7VHoBU8vjir//pOT
         Wx8W4NJhm5OHfAb5VFDyfEhUE0bYp129a/SUi4xvvwPkcZMcGiWnAoqgvzUfBk+zzT3M
         a0zz0J/WIa26d91DUFjDvqxCFTzyzP87qfMwBMWdt+QD1+WR+DDjBTurIGf+szbpNbA7
         VXcar4EJc0TN8cv5+NXZ7slyC3LT13Ap51CTWysdps0tHtY6ZFYs7I6MYpXeuAnT0F/g
         oNiuu9sCbxpClfTzpxT2Xygj6/qP5gtO6ci4ZKhSLdAmcLm3HtvLiLn6SnvfaKf6pPV0
         vbjw==
X-Gm-Message-State: ACrzQf00DOmy/dLR1erbxGqB38+A59ltpbHpjsZH1Tan9RurtkjkNb7O
        ozZuk0aTcZaArpgBne+2af4JXlEcdRoqWg==
X-Google-Smtp-Source: AMsMyM57y1wH1aH8VQGiQ42EtJlQBOaTt34PVVoYspxQhi5SgMCxKABcPSx8D6ykromEGibB3Kn+Qg==
X-Received: by 2002:a17:90b:4f4b:b0:200:876b:c1c8 with SMTP id pj11-20020a17090b4f4b00b00200876bc1c8mr1599491pjb.32.1664239398292;
        Mon, 26 Sep 2022 17:43:18 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q30-20020a17090a4fa100b001fb47692333sm67617pjh.23.2022.09.26.17.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 17:43:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <f52a6a9c8a8990d4a831f73c0571e7406aac2bba.1664237592.git.asml.silence@gmail.com>
References: <f52a6a9c8a8990d4a831f73c0571e7406aac2bba.1664237592.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 1/1] io_uring: limit registration w/ SINGLE_ISSUER
Message-Id: <166423939756.14387.1453058566232360884.b4-ty@kernel.dk>
Date:   Mon, 26 Sep 2022 18:43:17 -0600
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

On Tue, 27 Sep 2022 01:13:30 +0100, Pavel Begunkov wrote:
> IORING_SETUP_SINGLE_ISSUER restricts what tasks can submit requests.
> Extend it to registration as well, so non-owning task can't do
> registrations. It's not necessary at the moment but might be useful in
> the future.
> 
> 

Applied, thanks!

[1/1] io_uring: limit registration w/ SINGLE_ISSUER
      commit: 567a9ba00f144a1d2ec291e5188043c2db8c2b77

Best regards,
-- 
Jens Axboe


