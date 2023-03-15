Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5F6BB5E1
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 15:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbjCOOX0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 10:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjCOOXR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 10:23:17 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C81D8235E
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 07:23:09 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5445009c26bso145964587b3.8
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 07:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=happiedata-com.20210112.gappssmtp.com; s=20210112; t=1678890188;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+GxGRmg4EZZMQMXhR0+a0sEgTawsgLaMnKjOgJ+RVkw=;
        b=wrNr0moG9LE4zVWTPsDW8pq31zjdIO9cICDatA/iTgKTaoWLdxf5GXZVrjE4gDbm9T
         wbmxi1mv3kmualupheZ1ePsijjdWImFIQEq/3YJ8g2c2+GR0MrBrwBqzPLbB8/jRqA99
         HK1Lt3rqjWK7p4pWFHYxU4jM9VPw5Cu2sqtdIUT4Ekk1c6VEpcIQPM6ssafczx3P5A0g
         hxLRJGUgoEEUhAqFH0vOmOJSmG5+VNN2GSgA8nOiaR53J8zCu9T0lU/RDs8zHl1pLQgp
         OrxUhZ/9nfwh410q+aLNcfebadN6Avl26rw6wi7o7cNfNpVxVGwVw98+4l2+HqBe5sF9
         1JoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678890188;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+GxGRmg4EZZMQMXhR0+a0sEgTawsgLaMnKjOgJ+RVkw=;
        b=A6inWF3GBapqaJsk5WGEhrsNiKX5V/WFlX8ogslU9Hk/Y+NFHSo5EhrSzcWzWxEyT5
         PjAFWhhLG0jlprgo6Oj2Kr/i/1HJ0K3khvxFn25JZgoVB4IPWwQ3wIOodg21XgBdeqkK
         aUp8eQENVRJ/G3vB9nySM5bZC4514yARmi01HlRBY7669+NlBcaQI/flPmA5Wn/lpWOA
         fYdJ6wN3sRpeq3qlirei/TlU/WiLGi85tC3QM6SBNHy3IIHFG0rqtLnBArlTF2E6eJsf
         2stsERTobABpHDtImyoCDcS2QzVFp4g3KXk+9rTbC8pgme08RcxDmyaQVcHT5hdCUs7Z
         saVA==
X-Gm-Message-State: AO0yUKWi8+ddlfagYCHdY+BASlbYXef4IMAIEN8EhcYMbtm87l8PMHh1
        k5ucfbjgRkAFfllWtoYi8hR/gX86SZsTVxKAncwWqQ==
X-Google-Smtp-Source: AK7set/a/Gx6LiJTvmBq+TBlnXE4YnV2KmOKcs7lZYSmVpMr280pR4rKMG1oG+lE0JX8xSVyWAs2ix3o+emVCDu3zlY=
X-Received: by 2002:a81:a7c2:0:b0:541:a0ab:bd28 with SMTP id
 e185-20020a81a7c2000000b00541a0abbd28mr30525ywh.4.1678890188561; Wed, 15 Mar
 2023 07:23:08 -0700 (PDT)
MIME-Version: 1.0
From:   Andres Chico <andres@happiedata.com>
Date:   Wed, 15 Mar 2023 09:22:55 -0500
Message-ID: <CAFx-5XZsLyXOEy4QK_v6BMjV01AT-s_vdwhLvE7T=RSCfEcTHQ@mail.gmail.com>
Subject: RE: HIMSS Attendees Email List-2023
To:     Andres Chico <andres@happiedata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,FILL_THIS_FORM,FILL_THIS_FORM_LONG,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Hope you are doing well !

Would you be interested in acquiring Healthcare Information and
Management Systems Society Attendees Email List-2023?

List Includes: Company Name, First Name, Last Name, Full Name, Contact
Job Title, Verified Email Address, Website URL, Mailing address, Phone
number, Industry and many more=E2=80=A6

Number of Contacts :-45,328 Verified Contacts.
Cost :-$1,957

Kindly let me know your thoughts, so that we could discuss further details.

Kind Regards,
Andres Chico
Marketing Coordinators
