Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DC4464766
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 07:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240046AbhLAGwW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 01:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239629AbhLAGwS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 01:52:18 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8D3C061574
        for <io-uring@vger.kernel.org>; Tue, 30 Nov 2021 22:48:58 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id a14so46899899uak.0
        for <io-uring@vger.kernel.org>; Tue, 30 Nov 2021 22:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=f8wk+sojcuwRtPLYSZC0dtk6/CgkMRG+G8t+c2SS16s=;
        b=kqMRWU1zyc4dddR3Wj0BXDwNSg6ZICUpKYhNpr2HvX0bZToBLcRaf45hPesaFxFuvK
         0gBS19M6yHGVwuyRyMBG8th8R5R3MYQ78tl9d1h374ph3p+b4YfFkHu29S+P2S6kTX1a
         N1cnxpbuuciNB+W1nC5gobEVJzOqwWF9fp2FmctNKUmj9rnXwLw4UXhH7UUJojj+I/Tz
         f4Qm8JsXmYH+1EYr++xZLaf9y5waKuljMuQPpUdysvo//T/T7bA/u6/pT+Cu1/GedGSz
         yMklyst/5yYdgJuKvoSCHHx7o8Ba8uSQH0Unpw7ZVdB1qsukLWg91Z085GJZAuPsG7J9
         H6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=f8wk+sojcuwRtPLYSZC0dtk6/CgkMRG+G8t+c2SS16s=;
        b=KNxFqqyO50+6htaxgAykB3rWWj8Esza/dTzZx3jnz5ZcOXxoG6Y5aKDJtTBc5mizKy
         rS3BsS4pwYBn76MGmXp5pQZvmfNNX7mrB0HbUQdvCbbvCYZelXw8xFwPmirf6wOI+//W
         MaLLETs9eaZ4tQtICvLGl00BPudGOpHp5JXm1Nbg5pojfX29vZ+yAFfivAliRipMF6Re
         ptKU0MrgNymWIqxtmr/t1SYYNmjo0kkLgMaYuw15XN6EtQfu2l4OrGKjXIQ10GAdrLCg
         xr9zUi8mg9WbPIh4BeWIGdzyYN0s8E/GbJ0jmhNBtBwEyDIBGUiScE4ld/BFp3/YnFNt
         dRSw==
X-Gm-Message-State: AOAM530swIpYBSibZBcTGRJhdRQRqI4fFEa3uIDs7qKHdyGgppZKzgqZ
        3bSxtWyt9UpyTvBJZ2OTLhUrJPdkZB5l7w2JIeI=
X-Google-Smtp-Source: ABdhPJzvn9ymW4Pe93uYcqCrGV5cgtNCnAzF2FwK4LvkttUso8yA6inzuAMvf5NhOmEiNYuQTrMHQAhpk75A065/NDQ=
X-Received: by 2002:a05:6102:2922:: with SMTP id cz34mr4812400vsb.56.1638341337738;
 Tue, 30 Nov 2021 22:48:57 -0800 (PST)
MIME-Version: 1.0
Sender: aishagaddafi1056@gmail.com
Received: by 2002:a59:93cd:0:b0:23d:8159:3c4 with HTTP; Tue, 30 Nov 2021
 22:48:57 -0800 (PST)
From:   DINA MCKENNA <dinamckennahowley@gmail.com>
Date:   Wed, 1 Dec 2021 06:48:57 +0000
X-Google-Sender-Auth: uSQm6jp8uj_JxyK_iyZ_3Tnk-S8
Message-ID: <CANtwLy0JKbb+xQJjxZJTVrbtqkYNwwVGCnnbOo8sk=S2nD0_mA@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello my dear,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina. Mckenna Howley,. a widow. I am
suffering from a long time brain tumor, It has defiled all forms of
medical treatment, and right now I have about a few months to leave,
according to medical experts. The situation has gotten complicated
recently with my inability to hear proper, am communicating with you
with the help of the chief nurse herein the hospital, from all
indication my conditions is really deteriorating and it is quite
obvious that, according to my doctors they have advised me that I may
not live too long, Because this illness has gotten to a very bad
stage. I plead that you will not expose or betray this trust and
confidence that I am about to repose on you for the mutual benefit of
the orphans and the less privilege. I have some funds I inherited from
my late husband, the sum of ($ 11,000,000.00, Eleven Million Dollars).
Having known my condition, I decided to donate this fund to you
believing that you will utilize it the way i am going to instruct
herein. I need you to assist me and reclaim this money and use it for
Charity works therein your country  for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die.. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.

I'm waiting for your immediate reply.

May God Bless you,
Mrs. Dina Mckenna Howley .
