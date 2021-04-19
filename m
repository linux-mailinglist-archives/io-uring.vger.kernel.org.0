Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E586E36403F
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 13:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhDSLLM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 07:11:12 -0400
Received: from us2-ob1-2.mailhostbox.com ([162.210.70.53]:46078 "EHLO
        us2-ob1-2.mailhostbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhDSLLL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 07:11:11 -0400
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hello@oswalpalash.com)
        by us2.outbound.mailhostbox.com (Postfix) with ESMTPSA id 5C6241811FD
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 11:10:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oswalpalash.com;
        s=20160715; t=1618830637;
        bh=uX8Nj4JYkK19Kuaa5C8FzpPcxMh/FXkPH4rqIFCsR2g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=FTDCeQWQWeovq1itiyiag9QCEti3ukpxz2UUNRkuf30BFKAQ01llLf4I3f1ybxgW8
         YAhOQHPJ76snPYeh30+Vr6nV4+zTl9B6+zfw69yyGPGiLg+MXbtCBt89C8bOxHkFDx
         NJaYTBoNYFo37L2k8+9uzQiQubLot0k06eyzNdqk=
Received: by mail-lf1-f47.google.com with SMTP id h36so1122790lfv.7
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 04:10:37 -0700 (PDT)
X-Gm-Message-State: AOAM53279OpYJ9Z55Durc5DnzvhKCUcXycWxhGBB4vO3CHPkFQ9kWqee
        GzXV3+YY6+35b9Xks8CnrqYIG1hMrzppEuxHI0M=
X-Google-Smtp-Source: ABdhPJzW23wSqwSosIcW1FABHpGT24BpIs5AgHuammJurNJHo8R1BE1rigU41o+AXZR7vPLHb/KnrHsdE4mDUzKVabU=
X-Received: by 2002:a19:6450:: with SMTP id b16mr3005919lfj.6.1618830635608;
 Mon, 19 Apr 2021 04:10:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAGyP=7cWH6PsO=gbF0owuSXV7D18LgK=jP+wiPN-Q=VM29vKTg@mail.gmail.com>
 <a08121be-f481-e9f8-b28d-3eb5d4fa5b76@gmail.com>
In-Reply-To: <a08121be-f481-e9f8-b28d-3eb5d4fa5b76@gmail.com>
From:   Palash Oswal <hello@oswalpalash.com>
Date:   Mon, 19 Apr 2021 16:40:24 +0530
X-Gmail-Original-Message-ID: <CAGyP=7c7vOXoOet-ZdF46Z1nkvE3odqJXQKSeX9cx+rQ4FDtWw@mail.gmail.com>
Message-ID: <CAGyP=7c7vOXoOet-ZdF46Z1nkvE3odqJXQKSeX9cx+rQ4FDtWw@mail.gmail.com>
Subject: Re: [RFC] Patch for null-ptr-deref read in io_uring_create 5.11.12
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=M6Qz1B4s c=1 sm=1 tr=0
        a=OjAXoK3CVIMGaZH8qBVlRA==:117 a=IkcTkHD0fZMA:10 a=3YhXtTcJ-WEA:10
        a=Wd7zkvA6Ups12daFcnAA:9 a=QEXdDO2ut3YA:10
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The last commit I have is fe0d27d7358b89cd4cc43edda23044650827516e
(v5.11.12 release)

I see that the commit you pointed me to was merged by
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9278be92f22979a026a68206e226722138c9443d
is on top of 5.12-rc2. Is my patch needed for the v5.11 tree?
