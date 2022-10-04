Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651195F3E70
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 10:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJDIeZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 04:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiJDIeN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 04:34:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3CD3E76F
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 01:34:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id i7-20020a17090a65c700b0020ad9666a86so1198113pjs.0
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 01:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=J73b4rCSJChNmSabTX0OyIO95LIj8AGlGWLppEgGIjc=;
        b=ZfFSgvDosIVl09I7H2pdNGb1D5SzPrlHh7nSSH1l7jDCkwospk4qVd91LN/WyIGHG9
         tJYoaiYl4ZjUSszz5zbTYlTmKKIvcfeKIh0dGKGbHDE3FZXZoZaByMR65mNMfl+NLtPa
         N7iDLhwnl3Mon+sINIqrYWNM57C8LzMQlpdwsCgws2cDhFS2jCAZ3p93EWurXxJhpfsO
         EGcjQ6wka1UTmShNzwPwmiKuapTgqE1PJitgWrWL20j5RN1hnyjvaVm7oHZYc8e5h2AP
         BUEU4NOdRFDdNQnpRZ3vD4ktNliXl1PW3UnsGDHGcuH9JPGJ2X5oAnP8ZJ373CPTJxkZ
         NRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=J73b4rCSJChNmSabTX0OyIO95LIj8AGlGWLppEgGIjc=;
        b=ag8+N5w+TTMDMDZx4wt/Oo/lKfS8iDzCsOClS0WO6lbNaH/fZjsDBJPTkQzSPILXz8
         lTNugNv0rH0IrgkNUzx2YnNnFDKDOcdW7Hz77CoRgZPNvIRgMneUQcUq0YhpCg6BKzZy
         oTsR6mGNp5a/mQef7DTHieGDqo26+c/8qgvDkSwFG8DVg9v35r9aHRrMJ5ps4RBXXam3
         U18RNKgfm3yAGyHePBwXxY4NsNgayoApixvX31xOxPaG9awf7MqAURWSYrHB6aopGz2i
         XTOiMQ7/0JnErzRyf3XYKjnMJliCgG8Qn5eAWoVlpHL8Url09fRKR7yGj1H5rCtZ8AiZ
         aLmA==
X-Gm-Message-State: ACrzQf2qFZmsapJCuaWaPiqXb9Xhd+l38/iMWqwzMIjKgE6vqOOwE+JT
        5R9xLg+cEs9wVfS/MF3cOPLrYU3Dkrx63OuRSg==
X-Google-Smtp-Source: AMsMyM7XjahYQYFgcEN4AwvNx4qkz3Q6gkJNsJNz/U03sSH18MgHk02+kSCy/tr6k1PlM/909PWE8iW8N+UVQYMQOck=
X-Received: by 2002:a17:90a:1617:b0:200:9da5:d0ed with SMTP id
 n23-20020a17090a161700b002009da5d0edmr16121713pja.90.1664872445965; Tue, 04
 Oct 2022 01:34:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:902:ce86:b0:176:de47:a480 with HTTP; Tue, 4 Oct 2022
 01:34:05 -0700 (PDT)
Reply-To: annghallaghe@gmail.com
From:   Ann Ghallagher <danawadja@gmail.com>
Date:   Tue, 4 Oct 2022 08:34:05 +0000
Message-ID: <CANqcXDdNGdV01ZX+Xi1RkSzs_MP6yKJcivu22zXP4esMUX--zw@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Dear,

Nice to meet you, hope you=E2=80=99re enjoying a blissful day? I'm Ann
Ghallagher. I'm a U.S. Army officer from the United States of America,
I am supportive and caring, I like swimming and cooking am gentle
although I am a soldier but I'm kind, wanting to get a good friend, I
would like to establish mutual friendship with you.I want to make a
deal with you so if you are interested contact my email
(annghallaghe@gmail.com) or should I tell you about the deal here?

Regards,

Ann
