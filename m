Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B54948D9A3
	for <lists+io-uring@lfdr.de>; Thu, 13 Jan 2022 15:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbiAMOVI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jan 2022 09:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiAMOVH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jan 2022 09:21:07 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57922C06173F
        for <io-uring@vger.kernel.org>; Thu, 13 Jan 2022 06:21:07 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id d3so19899671lfv.13
        for <io-uring@vger.kernel.org>; Thu, 13 Jan 2022 06:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=4MT+maaW7KJhHwmqQCGbkCocAW7fIWIVZCbCsyf7Ohw=;
        b=SR4oLuQgVFq1VAQtuebucfrTGumm7h6N4+0/oTs3DgisGBbBaFp0NOkcWosy0lU30q
         1m2UKamR48p8VksIvkZrLaeSgxoH+emZGuSPXM1oXZHLZRFeYj66iVh/np6M7HdjHwMJ
         uRB5N0J+GeZXQeLApRz2gU/1qPbwUEgOIGuW5iQxEExlZMc5QHkQfJUq/dpDJ4qyWB2d
         E4w0I4c+dK280y8kGnZwIoy0lwmQTlfbhtnQZjvB2AM1CGS8xZ/KpxQrRwvt/VHPLob3
         E4bFL35wiSV20a9uxcJVRDdRwx27RGk9SflmyHAHDM3uRHTmVqMufN3MDBy8PRFvWuTG
         NwKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=4MT+maaW7KJhHwmqQCGbkCocAW7fIWIVZCbCsyf7Ohw=;
        b=t2U9iOPvc8kF8fh/pn0UWBmLEyhC1iHkj3lJVCfaEHlHS5syC0b74PBXF7QCK4IvwU
         Wq77HXnuQ2/lhYrnSb6XDJDlCLWmRrxTsdqhO/EQ6v6fbu27oGhOEnsIKcLKZAaVP0c3
         Ky+SlwKCnXgQyH/2h5b8YOur1MHVdb7SptopZWFXRrdJvBM+XKczwF+zSdsj827fgYHW
         OgE+pJpwulNOIdm9pAUodZ9xLRIuW+HcwshEqvUbHHK6CgzmUl84QmwYudv+XfgWuBWs
         TheyctaDwkjg8lasZJ2KKD+G2HOxKSj5/bqNDuD2dAGp1FREFCANqs9LWnvW3LZ1mul4
         tX4A==
X-Gm-Message-State: AOAM531ZW3WYB036id6yta8/bG1mciyca2rQjkgBcDY3aJvwEdTvrxQO
        UrWkpVHW6JUXzPdva+4vzS+fDEmJixk2P6u8HWc=
X-Google-Smtp-Source: ABdhPJwKTCgay/HAEvc+oZ5AdE3AbsYZREdy3CjOF5MPvmcAKYlkKjuyiHqSTaCHtRxFbisOUFMQmizhdnKbaIFTU7k=
X-Received: by 2002:a05:6512:220b:: with SMTP id h11mr3310483lfu.443.1642083665584;
 Thu, 13 Jan 2022 06:21:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a19:f204:0:0:0:0:0 with HTTP; Thu, 13 Jan 2022 06:21:04
 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   Orlando Moris <silvanwaneri@gmail.com>
Date:   Thu, 13 Jan 2022 14:21:04 +0000
Message-ID: <CAJu4-U9uj5-Hdbvw7raAyRhHBte3QCBCiBo+F4Ch9FbgVFrL4A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tere! Teavitage, et see teie postkasti saabunud e-kiri ei ole viga,
vaid see oli spetsiaalselt teile adresseeritud. Mul on pakkumine
summas (7 500 000,00 $) mu varalahkunud kliendilt insener Carloselt,
kes kannab teiega sama nime, kes t=C3=B6=C3=B6tas ja elas siin Lome Togos.
elusid. V=C3=B5tan teiega =C3=BChendust kui lahkunu l=C3=A4hisugulasega, et=
 saaksite
n=C3=B5uete alusel raha k=C3=A4tte. P=C3=A4rast teie kiiret reageerimist te=
avitan
teid selle re=C5=BEiimidest
selle lepingu t=C3=A4itmine., v=C3=B5tke minuga sellel e-kirjal =C3=BChendu=
st
(orlandomoris56@gmail.com)
