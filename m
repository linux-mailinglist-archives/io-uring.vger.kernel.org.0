Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A1F48D6CA
	for <lists+io-uring@lfdr.de>; Thu, 13 Jan 2022 12:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiAMLnd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jan 2022 06:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiAMLnd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jan 2022 06:43:33 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C84C061748
        for <io-uring@vger.kernel.org>; Thu, 13 Jan 2022 03:43:32 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id o6so22041485edc.4
        for <io-uring@vger.kernel.org>; Thu, 13 Jan 2022 03:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jhWn7T4hrA7xl2IAMoVZUWsxv+GoNPnOF3yuOrAjNoM=;
        b=O6znUgvgKgL5BdP5cj72YFiTXwMCfhJznE8ThXGEZ7LZzTrrSUuTHBOcjh8j3mH27z
         YRt2Us7gNfeEpsE+RpCciNjcfFzd5IyvoXgF1UWciTNkT8RSsWHH0DNHtItBTzcwV2nW
         bE/T3a99hBV5dH6ED3zjFzG7pSfeEUTtik3dRKzg/TPuOe9M2F3L8obGUKvBS7opkfFv
         J5I7ccOPe0SUdifTHx4D6NvCrh8NNfV4BKSMAR1hZ1VfEBJLOs9YwwD4ptkKMbNBUrMA
         UlNi9tyyqpKh+vwOLaOOOPevAwxHAFy0HqCgrvEf36MEAhJCIGyubUD4dfP88QbA08Z3
         B9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=jhWn7T4hrA7xl2IAMoVZUWsxv+GoNPnOF3yuOrAjNoM=;
        b=eZJpZ65gHM8wwSkYfLsqwXmkU5yLpSORToKCA4dlj8nEGAi7yybx/vZrlyW/zKPrq5
         oPs63KH8HZ5BetiMRc7SFughVdWgnsJ8ryrtOkiDCjvWQVHxEsX4oa9dXVfBgLdH5l7m
         QaUsx8Qo3IbSNk+VyAhMSBiGTRvT1ji51s2DcCUVqcVD6g6EOk0NxbSqgwdELW6uuyTQ
         J1JbCz65efQHm6gekRlwESRVlqJXFgVfJXeCHkFQ4za8CnhxqH+53+GXO2+GaO4tGcpK
         MLb2Up4ROZVYAEyKJNst53R5izfU0RbkouNF1ZXFj+gTD5DyBrpstvifIb1aV0X293Gx
         RG3A==
X-Gm-Message-State: AOAM531pOHXiGe3+xv70ILUDxYwk3bG4a9uy8qg4d9SSDSgmrgf2E/BD
        gePu67EHUOTvooioJVr+M0TpdcJPJUxRORt9Kwo=
X-Google-Smtp-Source: ABdhPJxyoiY8VXI7Ap+xAKk2PRUCGBv2OlVGjIuSXN6ReOxXW5RkQkxED+IDptohray8Xj361uyQT4in8afbYhKcEOc=
X-Received: by 2002:a17:906:9251:: with SMTP id c17mr3129257ejx.611.1642074210635;
 Thu, 13 Jan 2022 03:43:30 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:3348:0:0:0:0:0 with HTTP; Thu, 13 Jan 2022 03:43:30
 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   Orlando Moris <officebe274@gmail.com>
Date:   Thu, 13 Jan 2022 11:43:30 +0000
Message-ID: <CAL_4xW-9DBwe67n8ZW0SFDOPUqWdawWoro75_sa2TwTxQmPqdg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tere! Teavitage, et see teie postkasti saabunud e-kiri ei ole viga,
vaid see oli spetsiaalselt teile adresseeritud. Mul on (7 500 000 $)
pakkumine, mille j=C3=A4ttis mu varalahkunud klient insener Carlos, kes
kannab teiega sama nime, kes t=C3=B6=C3=B6tas ja elas siin Lome Togos. Minu
hiline klient ja perekond sattusid auto=C3=B5nnetusse, mis v=C3=B5ttis neil=
t elu
. V=C3=B5tan teiega =C3=BChendust kui lahkunu l=C3=A4hisugulasega, et saaks=
ite n=C3=B5uete
alusel raha k=C3=A4tte. P=C3=A4rast teie kiiret reageerimist teavitan teid =
selle
re=C5=BEiimidest
selle lepingu t=C3=A4itmine., v=C3=B5tke minuga sellel e-kirjal =C3=BChendu=
st
(orlandomoris56@gmail.com )
