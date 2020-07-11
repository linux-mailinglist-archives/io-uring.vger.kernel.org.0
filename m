Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA23A21C4EB
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 17:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgGKP4v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 11:56:51 -0400
Received: from mtel-bg02.venev.name ([77.70.28.44]:40402 "EHLO
        mtel-bg02.venev.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgGKP4v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 11:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=venev.name;
         s=default; h=Message-ID:From:CC:To:Subject:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Date:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LWff+HXIDnpT1C9yV637FSFXwGVa57bMP6uhGSmlnX4=; b=bcl1DYjpD/fjSkSbdSREysTakP
        8LYqF+5B6XS3qc4NfOglP/2QyEXVHLWF7PbrMSqlR74p1Ue4Fg2Z+zmzeXJO+09yb+ue1p7Yl8nP8
        DmL1cxdOUPK8G+DwG5S4o7NjQa0x9CcRvK1fwiTIM01dKWTJSgx8GJ2rqN3flb+D3wHW59oMJQMje
        yARx26ZMoRlLtwFfm4HvBo7NSZWtBrGZthU4T5mQbI3q79S6Z3eRZ4pgY3IbF0yuUGuHEeopXrED2
        utWzxeE4sO86eCANiWauWr7tp/QHSDgoadraHUiyyzgLy91K2EJZxjbGWYU2QnUfRREtwIEYMRlUj
        DuJKYv1pr0mnA1hJp3NVjKTsmTvO54IFflIJmqNArw0gYTWHKQzsguluURURtFFm6hfHerBUhyDS7
        8fB3A/nUoSP962DAG6DwBeMByLKiYYgHblvpULb4JvPNP9CVfjPobYsSJJ5jjMfNqCEpWHrnHV3wA
        LIIsWZLBm8/JKBsmqLH9L3pMusBlK4oPT1fAydNNH0k9areNcsFLSDdwNYm+Pw2lb5313SiQRkdFR
        tKXSJigonios7SJyHxMH9radeDQrp0qG7OOFA2G2n7eGBfyHRzH41p4vpNYO+JLiguKm+KnSZ6Uzp
        rSds+p6WJaPM/E1NYdo8ek1veVYCW7hXiBiHRXDjE=;
X-Check-Malware: ok
Received: from mtel-bg02.venev.name
        by mtel-bg02.venev.name with esmtpsa
        (TLS1.3:TLS_AES_128_GCM_SHA256:128)
        (envelope-from <hristo@venev.name>)
        id 1juHri-000bJN-0h; Sat, 11 Jul 2020 15:56:48 +0000
Date:   Sat, 11 Jul 2020 18:56:37 +0300
User-Agent: K-9 Mail for Android
In-Reply-To: <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
References: <20200711093111.2490946-1-dvyukov@google.com> <7d4e4f01-17d4-add1-5643-1df6a6868cb3@kernel.dk> <CACT4Y+YGwr+1k=rsJhMsnyQL4C+S2s9t7Cz5Axwc9fO5Ap4HbQ@mail.gmail.com> <7f128319f405358aa448a869a3a634a6cbc1469f.camel@venev.name>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] io_uring: fix sq array offset calculation
To:     Dmitry Vyukov <dvyukov@google.com>, Jens Axboe <axboe@kernel.dk>
CC:     Necip Fazil Yildiran <necip@google.com>, io-uring@vger.kernel.org
From:   Hristo Venev <hristo@venev.name>
Message-ID: <D5603995-0AD3-4CD9-9D93-9A9F84B2FF45@venev.name>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On July 11, 2020 6:52:19 PM GMT+03:00, Hristo Venev <hristo@venev=2Ename> =
wrote:
>On Sat, 2020-07-11 at 17:31 +0200, Dmitry=20
>    PAGE_ALIGN(192 + (32 << n) + (4 << n) + (4 << n))
>    !=3D
>    PAGE_ALIGN(192 + (32 << n) + (4 << n))

* also power-of-2 aligned=2E
