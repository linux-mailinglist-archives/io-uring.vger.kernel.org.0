Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E547A9A0C
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 20:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjIUSfw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 14:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjIUSf3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 14:35:29 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784D1ACD1E
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:02:45 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2c008d8fd07so21482731fa.1
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695319363; x=1695924163; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VEEVVCMERfgi3uAY7J4zFeuORF8q9XNaRc0T3nkAbIc=;
        b=A/Ry+UdjdqnJ/VbSn5lJngVUxp5iTmp0+4J8SF81relm7Gp4WHOb9IHhgOip9Fz34Z
         YOOVEJPa/xKh9PXaOSHknr1OnD/bs98Zt/TVJ7QD+OCiiA/fABb0342nY/vN2U73CZm/
         mbvxevsuwkp5qj51dhyMLhAe1Gv49nMlQorY8n2kEF4UIROSGN9wts2ufiH5wrQOqOeL
         KTfPrfb8+MiL4b8PyNkxsuQynk/SJcflSzzgms1N158Dm8qpN9IbbKEu4UEtnCOjwqOu
         20CC36om3xxnhYQ3bjhyu3GoMFQ+PDEjg86hFeKFIm/MqXl0ExN3oano/Rti0uOX/inn
         QzAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695319363; x=1695924163;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VEEVVCMERfgi3uAY7J4zFeuORF8q9XNaRc0T3nkAbIc=;
        b=R+dyLnkGWPNwPiKIrR0/hCgGySZUNsX8m+ycZY7/1gewc+FlrWpRbsdtP52d6dBrBe
         IcOQpEJzAbXECUQlHenVoZLTQ1/LCGVta15oP3kbBW3oEWfYES1/gN8oaPaYyJfWGwKB
         H/pgkf7vZXKfx5B8BpnVyvY5m6hQ/RuVyKGXIrVJtY4xzrHDHNGEK5G1qFvAY/xWCB4+
         iTlU9l3/4BMYh5md+KqQrazM4HM36sTaIIKPIe9aAEALIEGmt5g/XPe1T3nKM3zRuEKX
         me1/2S33SMSiiFiCb9GUBuU0AMOZsBOLE8QHhGvlJiH6wV9nNnHh5eh/IJd3L/KrSXz5
         EoNg==
X-Gm-Message-State: AOJu0YyDYT7vWyajuuWae1MPyEwE7u3TKOu38DmkKJBSlPmdtBGKHRnZ
        KCVrK67KPDtI4UaLulJiPVinNHFNqTRKyBc+UR8eHiSsRKqDAg==
X-Google-Smtp-Source: AGHT+IF/DWX8AXSNiU230zDpJqVdfcL2VxpI1f3Bn9UrIYP4X6ump6Llh+QHQCoYYTPOCRmAgr32GZiolNepUmM6bLA=
X-Received: by 2002:a05:6512:3b12:b0:500:b828:7a04 with SMTP id
 f18-20020a0565123b1200b00500b8287a04mr6351683lfv.18.1695304302147; Thu, 21
 Sep 2023 06:51:42 -0700 (PDT)
MIME-Version: 1.0
From:   Esther emma <estheronedataprovider@gmail.com>
Date:   Thu, 21 Sep 2023 08:51:30 -0500
Message-ID: <CADs-dhZF0Nq23dkULYuBoedudH9sdExtkXjZpbQWYbaA125p_Q@mail.gmail.com>
Subject: RE: HIMSS Global Health Conference Email List 2023
To:     Esther emma <estheronedataprovider@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_50,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Would you be interested in acquiring the Healthcare Information and
Management Systems Society Email List?

Number of Contacts: 45,486
Cost: $1,918

Interested? Email me back; I would love to provide more information on the list.

Kind Regards,
Esther emma
Marketing Coordinator
