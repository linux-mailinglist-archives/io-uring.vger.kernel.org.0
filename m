Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB205BBD89
	for <lists+io-uring@lfdr.de>; Sun, 18 Sep 2022 13:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiIRLKy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Sep 2022 07:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIRLKy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Sep 2022 07:10:54 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E394814090
        for <io-uring@vger.kernel.org>; Sun, 18 Sep 2022 04:10:52 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id s11so13485557ilt.7
        for <io-uring@vger.kernel.org>; Sun, 18 Sep 2022 04:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=5dlVQkg7m3jbrM+RSFK5kzvqkfDjBaUAUZpra2spTGk=;
        b=Yh7aPhecWTDgG5sYOY0PJSODBcjpSiaC+yZJg8qCDerDE960u4VC+9LKwST4s7Q70k
         3XfPr4ap7+wSXck945G8j1Nd71L+obf1j0Rvr2mDc6yXQalj9jtpiy7b1jKruLKrC3M6
         30Df7MxKB5YLdlsgw9G/1pNM6oHa/4Ht4w2xqmmFQ+IPPgz8tZuFZvHk9V7Jv4EDD8PT
         iav0DV9RAcocblNlMcbEl2M6fvbjRgevTe7CPqx3jNwBphm2idltTg+SeSPDzWVa3wSB
         /xqH+fZ+n04kyddCMM9hxilt3dQvVw4m7Hm/hVrkqtgNKOGANF9ozDclKI3VzcefsiR3
         Al0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5dlVQkg7m3jbrM+RSFK5kzvqkfDjBaUAUZpra2spTGk=;
        b=NeQSvN5TGE82mWWBY84P9hWdvUf+BE1Z5eDizYVEMkMQlSTuuuT2zlYNJcDns+POTU
         7QDi6+fImM0nyzqxFKEdC7Ib9XZyzTRawaWMkQWQjIBKg8xdcoxP9YE2qhCwbOnvH5KS
         QbYcz9uaUNTJ9kebYfQhK6J3Pb0PTgq22J6A+AueJAFUtmVU/pRaxsj7SesESfKUcRiZ
         RUEO3wRERhc6t2xiB+dEn40befLT6lc9+MEfOHoekcqlkx34yvStZ2tpNHTwDAKj9uuL
         cDhA410ASCwrUz/VEq8f3Kn+bhmhAmO03WZgSl8wXEoYKgEVMislgpTlSNMOCe6TjU6E
         EnGA==
X-Gm-Message-State: ACrzQf3bxh2PBNFU5+82AKFE0/RELtkKTxd1PYBHsH31q4jfVdFFI3nQ
        qqbqeSXVZ5eMHcbPxYd2Ej9NIQ==
X-Google-Smtp-Source: AMsMyM7XOnJBTHS3LQwpR1po9I6sSS903n08EBfB4G+CII9OitzUmAu/dHV69sGa8B5PIvJGQ4Pfow==
X-Received: by 2002:a05:6e02:18cd:b0:2f1:f4be:8802 with SMTP id s13-20020a056e0218cd00b002f1f4be8802mr5429430ilu.56.1663499452270;
        Sun, 18 Sep 2022 04:10:52 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e4-20020a056e020b2400b002dd0cb24c16sm10769931ilu.17.2022.09.18.04.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 04:10:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <dd6406ff8a90887f2b36ed6205dac9fda17c1f35.1663366886.git.asml.silence@gmail.com>
References: <dd6406ff8a90887f2b36ed6205dac9fda17c1f35.1663366886.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/net: fix zc fixed buf lifetime
Message-Id: <166349945138.4999.237055933730082351.b4-ty@kernel.dk>
Date:   Sun, 18 Sep 2022 05:10:51 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-355bd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 16 Sep 2022 23:22:57 +0100, Pavel Begunkov wrote:
> Notifications usually outlive requests, so we need to pin buffers with
> it by assigning a rsrc to it instead of the request.
> 
> 

Applied, thanks!

[1/1] io_uring/net: fix zc fixed buf lifetime
      commit: e3366e0234971a09f0e16f0e6fa16f4cbae45e47

Best regards,
-- 
Jens Axboe


