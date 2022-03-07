Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5069F4D0A88
	for <lists+io-uring@lfdr.de>; Mon,  7 Mar 2022 23:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241145AbiCGWHG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Mar 2022 17:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242951AbiCGWHF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Mar 2022 17:07:05 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8F18BF28
        for <io-uring@vger.kernel.org>; Mon,  7 Mar 2022 14:06:06 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id e188so2641541vkh.2
        for <io-uring@vger.kernel.org>; Mon, 07 Mar 2022 14:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=t6DcQhfFfmQsTksI9MS4VLvsVDH6vcj7lwbO1DMdjXk=;
        b=Qd7HFWwPxf7yik/AymTZePKEvLjjPfS5pJ3opFFKjvOi09PcZd188/83gS1hT19EVO
         xfF5yPRfmUwnnlt174QERVqZFmhk+/7lYovzLYgVDQAqT0+lbZ2ibPFbrgjC9FjuWOHz
         4QWrOH5TG0Q/DTxf9zgf0/HlPvhTF9U5ngCgRi4zbVUZELqTSP6KWONFl893Q23vWPpT
         Sjy2J+Tt79vIGZfooBhVj1I3wezQDw2nvgO4TuE+/rc1Kxv/geyeBULcJv7/+L/IRcn5
         l+ILv89yDg51BaV96laoJjDmNlQeoy48BRh5kLSPGWssApsn/9mSMPZBLYrAEUiDBPA7
         B94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=t6DcQhfFfmQsTksI9MS4VLvsVDH6vcj7lwbO1DMdjXk=;
        b=zJ509wODMYkI4tSV+zXr1WHyvZFhvSuB0T3/NKLIxlcCkRcD0m3Ak0PWAmaacxIS/L
         T+hL24LIyV+VG+AhsJ12HwIbZslmCShvSkRPPo+Iagn30/HBCVXVHpTISLZwNCgNe6s3
         tk4C/m+rum9h8OrrMFDV8PSv1tsBbZ3C3JuekZ+ZGKV0LLQai+noJ5j3V4D2DTPh7uyD
         lJ89XLSt/gN8M+ZTwIlFNfKykZ/HP1mHzIKLtjXyYpGcMWDiT99Sk2CezYaFjwrjjCuT
         2bIVRSdz2amVCRezH+g5FYLX3oRENT08bvKfvd2tpVRlZbUjmTupMf0X9dUTJJcUpLJS
         +rsQ==
X-Gm-Message-State: AOAM532GJHcxg5E/5EXfu8VdZGEvgRQ7QFzUybYQfqf4bWR9jGkvp+85
        9bbfpDOGxJcLrK2i5nOhdpkp4fHDv1ED/KC+qJ4=
X-Google-Smtp-Source: ABdhPJxebOfvUJWcNDluZgC0ClpjZZru++sh43D7/kzIOQKh126VWHHyx863df8XIHqdcWbojx4Opu+mW7gN6K0i2jM=
X-Received: by 2002:a1f:a90b:0:b0:336:ebf8:9ea with SMTP id
 s11-20020a1fa90b000000b00336ebf809eamr5481481vke.22.1646690765383; Mon, 07
 Mar 2022 14:06:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:a746:0:b0:297:1613:ce77 with HTTP; Mon, 7 Mar 2022
 14:06:04 -0800 (PST)
Reply-To: brookw094@gmail.com
From:   William Brooks <fillings.2017@gmail.com>
Date:   Tue, 8 Mar 2022 11:06:04 +1300
Message-ID: <CACONCTCp_w9Jz0_b8gN+Ao-ZsSqe7eKV=05TpNhPgm5=4hBe8g@mail.gmail.com>
Subject: Urgent message
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a2d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4782]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [fillings.2017[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [brookw094[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [fillings.2017[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-- 
Hi,

I am a banker working with one of the leading banks here in the United
States. I write to contact you over a very important  business
transaction which will be in our interest and of huge benefit to both
parties. Kindly get back to me for more details.

Thanks.
Mr. William Brook
