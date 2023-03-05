Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966DF6AB110
	for <lists+io-uring@lfdr.de>; Sun,  5 Mar 2023 15:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjCEOff (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Mar 2023 09:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjCEOfd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Mar 2023 09:35:33 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8543BE04B
        for <io-uring@vger.kernel.org>; Sun,  5 Mar 2023 06:35:32 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so6558450pjg.4
        for <io-uring@vger.kernel.org>; Sun, 05 Mar 2023 06:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678026931;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3if718PaFrkTynw1+ags3uyau+4BaA/REwSlIFf2Qo=;
        b=ChLbwyPsmGyRZQBoF+EVhYZmT/4edZKskh6N+rWyhaLG1AY+81PEspuohkyjuEG2Bd
         XD3aiCXYYVZsABJ+nB4WeW9pren6ZdEVl5KXMI4vhR7T+IWLag+RAn49rp5fQyWWOD87
         kxG+2geF4cj6kiYirsiOtaQjn+qS64hb8skgE64up881tR5KaT2LM2oDlfOAr6HEUqcz
         CNZEmvRJnzmEBb+gtuT2XNPbX5PdM6Brtl9ClNgDfef9sPUypAoz3TC1V/xYEzpDxGwL
         OeGRsvCtVGAXdrvobZH1pOno8S3C4fvncfj04xA6Dn7By0tQuiF7z6Gxo6p14Z+cQCA6
         i8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678026931;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I3if718PaFrkTynw1+ags3uyau+4BaA/REwSlIFf2Qo=;
        b=ycd98WgztqoYebiWWWQkhOjQHiPzzfzuAHebsGpPyZaX6NWxvEniFxUiJGzseYWXBn
         gu31OKE7liNQD+sm5xYLtsS964/25JuZRbJuiEnD3L+Tvi1Ye2saG7bvjQ2TXY+1RQ4c
         WKponhwXs4+3F6iPLZ7sPZ6nbHVGjVJ5DTUpN/8CyHiO731TlYydlqUA8vhQ2cfTLhn6
         PPUpPKNDha0SqBqTkZRzaAEcLTP3ALmIMkD+yIhBDBhLu033W5PjoyEXZQpB3myLT9Ii
         jcYgAjsQq7CB04GKe8l1rbj98v4cXmA1ZYehDKkwt3yvhbU0AhPHQy01lakil4JTVBrW
         PFVw==
X-Gm-Message-State: AO0yUKWO/+EYaX295Dxvk7LzWXGoGxXNpZDSXWDv91zEvfPn8KSWqfcS
        cFjpO0Fz+83rmemxNDRPk9Vo7kNVJnJHxTEyx2o=
X-Google-Smtp-Source: AK7set+pUkSABzNWTtb9d6EWM6Mvtfa0IgJ9P0yx8u/Gx4wiObdQ5JCFgG4+vILGWekmh/noeLIIhg==
X-Received: by 2002:a17:902:e743:b0:19e:b5d3:170d with SMTP id p3-20020a170902e74300b0019eb5d3170dmr3454826plf.0.1678026931370;
        Sun, 05 Mar 2023 06:35:31 -0800 (PST)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id kf15-20020a17090305cf00b00196251ca124sm4862683plb.75.2023.03.05.06.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 06:35:30 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2514ac14bffdffe0a78fd51c41698deb20d54cc4.1677993404.git.asml.silence@gmail.com>
References: <2514ac14bffdffe0a78fd51c41698deb20d54cc4.1677993404.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests/fd-pass: close rings
Message-Id: <167802693059.46805.5440720987736674735.b4-ty@kernel.dk>
Date:   Sun, 05 Mar 2023 07:35:30 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ebd05
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sun, 05 Mar 2023 05:16:57 +0000, Pavel Begunkov wrote:
> Don't leak rings from test(), we call it several times and have a good
> number of open rings lingering during the test for no good reason.
> 
> 

Applied, thanks!

[1/1] tests/fd-pass: close rings
      commit: 3533273acbacdc5b120dce12d3aab5c8e56e6186

Best regards,
-- 
Jens Axboe



