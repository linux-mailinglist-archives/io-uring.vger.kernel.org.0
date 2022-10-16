Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0B0600427
	for <lists+io-uring@lfdr.de>; Mon, 17 Oct 2022 01:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJPX2Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Oct 2022 19:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJPX2X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Oct 2022 19:28:23 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6C2367AF
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 16:28:22 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id 8so5756637qka.1
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 16:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VMohIhKQxapVvq+EKHTmWXrjwe1K5/FiOVgxxVQdD1I=;
        b=3Kdx9f44KhuYL0bpFYcqnhiJ3O6wF3TTNLmCArmGsMdBdE40zshmKjipagNxqvdOgw
         zqliSnYwhNdkfkJHHrjCVrF8dOLxQFz03jhg1+EqHdgdMCKFxkJnULo1ekrXJVVIpx43
         VrPTPexQeZLEbnlpaWIwi+/syNJ2askhT6U76vXnLdRcUOarpDUZ0PW/ZWePWro4MEhj
         2vE8sK5yGuZmQWTB83LByeTXOyVQCac2+m5XNtOFvpf3qPaAN1YzjzXziyCvD1mfnVfb
         dqG/bW1zeZ2RlxKNEQ9izU7hlpueRoFqgOu6WyY9y2HDhx/aOc4SLFtynMIiHPPmAr9v
         BvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMohIhKQxapVvq+EKHTmWXrjwe1K5/FiOVgxxVQdD1I=;
        b=0vHstTW5xoE1w8kt8L56rsdHGKUsS+6S35ZW2P3jPmKG/79kLxK8jgQLztzaRXcPou
         fsW0r9ZJHD0wK0pdP7bciy3wwSDrNT8GYB7WRoUE0dn6slrdzwVU1Iq/YypZuSWHZpH4
         Hnd7iy8Q0v28RLQmlFBwtHTHHCwRWqJg9QcJKF7L1Ry1fwAFCxsHJnVlW465uQNG6Sn7
         hpMz43VowhPTVS3y7yeXMQvP3N6eTNC/D53FfcHn5duBYYg1fksx6zLkDD7q5BMRIpyS
         nmVD51c7EGPXpu4+6eg1PyueSXNMOQ+aB38jkxiKQ+p5k7+Y3afzBcy0d5p0LuGBblJe
         v8Zw==
X-Gm-Message-State: ACrzQf305zbzXlVabjZho1R5rtkmFNHreDIGm94rA4xK0aikDczE4Nt5
        eqRaYojQ3bExdGSHkunjL4A23mZu1WrpYDXC
X-Google-Smtp-Source: AMsMyM7u+PQRJFOQp5VtbzYPLkrpmDR/tuH9KToIgVRHNB6LK4UBAHYJ0wOX4CqHBpS2NzPXhTTakg==
X-Received: by 2002:a05:620a:bcc:b0:6ce:c077:acf3 with SMTP id s12-20020a05620a0bcc00b006cec077acf3mr5927438qki.263.1665962901973;
        Sun, 16 Oct 2022 16:28:21 -0700 (PDT)
Received: from [127.0.0.1] ([8.46.73.120])
        by smtp.gmail.com with ESMTPSA id e14-20020ac8670e000000b0039a275607c3sm6615170qtp.55.2022.10.16.16.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 16:28:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <0c8bf4d5dd7135c990f4fa9232a54c8cd6cc024f.1665958020.git.asml.silence@gmail.com>
References: <0c8bf4d5dd7135c990f4fa9232a54c8cd6cc024f.1665958020.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests: fix zc support checks
Message-Id: <166596289885.8766.14672873037721098063.b4-ty@kernel.dk>
Date:   Sun, 16 Oct 2022 17:28:18 -0600
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

On Sun, 16 Oct 2022 23:07:35 +0100, Pavel Begunkov wrote:
> We should be checking cqe->res for -EINVAL to figure out whether we
> support zerocopy or not. It makes the test fail with older kernels.
> 
> 

Applied, thanks!

[1/1] tests: fix zc support checks
      commit: 4f962862daa7d54de4d21eeaf89130ad49040fa7

Best regards,
-- 
Jens Axboe


