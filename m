Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E616407BB6
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 06:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhILEof (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 00:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhILEoe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 00:44:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED91FC061574;
        Sat, 11 Sep 2021 21:43:20 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y8so298068pfa.7;
        Sat, 11 Sep 2021 21:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UpJmFShhcKMhZsJCwjbQ/homwZZN8sYg1ch9QrxdkOw=;
        b=b15+azSNqVBioVLACzDc4jZkTgv4EmhrudQEy8YNtXV0kKc9G7VP4J5nVOO1AZcVm0
         U5+NJqMroCTQrgLNqMstKEkJig+300hvtOXYXlz76ifKl8LLGyCkBJK55KH19p9TfyAX
         MujFux4R9n1mRUCB7wiwf2CqDlBinxzuwJfQx1X/BSe0XlXfUJP+LcUX+CvR3VHuwtLd
         HJHLUT+DoF8Rail+lMeXJecXWK5rO6MSYCudYuczFeVwCeHeb8d3RHAGpK9aoH/rgFMI
         b3Oe8Vy4BBsgHswGrK1XgUAQzo9qHzSs/YqHPNkSaHvt82wCPB7y5MvYQZW0udgh5OZb
         mr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UpJmFShhcKMhZsJCwjbQ/homwZZN8sYg1ch9QrxdkOw=;
        b=ZJi9jKsx/prttGiacAQtfl8lbPen80LpjQ1SSHgqWGaWwNPutC1iL8OL806NwErDzI
         9W3ZcOG9TeQlmgXyZj8T6lgNUN98fmLtenfC5RhMmosUDM2xXFghKy1ZneTP0X8M2t3L
         D0igMepC5i+dVhcKkmVz+dBOzKe+AtdLQRZdnxcu4/n/CaZZyxSnhTjurMCvVBtv0QhA
         A9R1GtexwugYk6YlDvNgPslVarsYl8yfm8K1nKLEjDVIInmITIl9lwq2bGH3U5f61Z1q
         CiMx7E0j4YHpGk1uqdOfeu7Fn9S9h5o0Q6SfBbhIQ74TIE61Y3v8FBiGJk3H6d/C6n0W
         slaw==
X-Gm-Message-State: AOAM531mtpheuyLLYssVk+N+k8fdWZt8IgmhY1tU8wFVpmI53lutjxiX
        GahagdqolR6bfsN8cn9JRergjv3sgF6Vfw==
X-Google-Smtp-Source: ABdhPJwi3ouKeSbMqrcMAZBCAK9+ojVc/k0Rwab2JYSO+3EEYT+VmBQl74+Djn4y1o4vr0OMAIuTPw==
X-Received: by 2002:a65:5086:: with SMTP id r6mr5132241pgp.65.1631421799997;
        Sat, 11 Sep 2021 21:43:19 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id q22sm3453283pgn.67.2021.09.11.21.43.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Sep 2021 21:43:19 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: io-uring: KASAN failure, presumably REQ_F_REISSUE issue
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <2C3AECED-1915-4080-B143-5BA4D76FB5CD@gmail.com>
Date:   Sat, 11 Sep 2021 21:43:18 -0700
Cc:     io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <825AB372-93CE-43C0-8947-EAB819547494@gmail.com>
References: <2C3AECED-1915-4080-B143-5BA4D76FB5CD@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On Sep 11, 2021, at 7:34 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
> Hello Jens (& Pavel),
>=20
> I hope you are having a nice weekend. I ran into a KASAN failure in =
io-uring
> which I think is not "my fault".

Small correction of myself (beside the subject):
>=20
> I believe the issue is related to the handling of REQ_F_REISSUE and
> specifically to commit 230d50d448acb ("io_uring: move reissue into =
regular IO
> path"). There seems to be a race between io_write()/io_read()
> and __io_complete_rw()/kiocb_done().
>=20
> __io_complete_rw() sets REQ_F_REIUSSE:
>=20
>               if ((res =3D=3D -EAGAIN || res =3D=3D -EOPNOTSUPP) &&
>                    io_rw_should_reissue(req)) {
>                        req->flags |=3D REQ_F_REISSUE;
>                        return;
>               }

The race only appears to be with __io_complete_rw(), not kiocb_done().

