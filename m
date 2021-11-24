Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983F245B2A1
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 04:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbhKXDan (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 22:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhKXDam (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 22:30:42 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB239C061574
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 19:27:33 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x6so3888561edr.5
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 19:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D3mlwxctVc4YiNL6SnhzyJ7Y2X2Dj6ittHGw+Kf7k0k=;
        b=FQFEgmxbILrG5odT1Ghdmx+0mB51dD6nTOs2uX5aQJDin9DYe/wkkczPtxjcJag/fC
         XAlCINVzNG6gNeiGEzmCsRZ2QH3AsLSuGxi0Vsl4Mm9UD1iZboHxKvnB1JAy4Bjjbyt+
         +m7uDe6YdsvE+k1rfVp85v/8zhTdsWSP7ZfPc7cQEuVy9minHTpXQjT9U6V0bhd4gncD
         4kW3gsQ7FZfMNgv09yYwtrl6HkzCj79fbf7FgCUmlA6hi88hRKf+yiH4ebF6QInaoSIh
         ZZ/OP6qO/EfBMxR8wIn20wXbNJI6wZMp30DGSuI5vUf5NKaNoBi4K7fiI46X8EE57Aho
         8sEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D3mlwxctVc4YiNL6SnhzyJ7Y2X2Dj6ittHGw+Kf7k0k=;
        b=46Bik2X49H8rogh5a0QA4yxY9ngaXtsRAUe5b8MlnLrKkFMrYzZbG2xj9ZyqUvKu9m
         IBMBeuLgUPzpI2SS8o0j/Ra3tjQtutCkAWhFpLAeazch73sui2njgZLDf/y9JYGQ2Muq
         EjS4eyrj6MwrgmTnRj6eBqIpyuFt5NX71cE2DLYGHBuqTlizgE50QYAWYQhcBfXji5Tm
         o1ABI0FMYi5FC8WiFg+ahdqXxA7KXMg7vm1fLlr8UhUuwS/QeUItrmaK7qMxAwEXmvq/
         toyDx0wbDAMWhkJReXaxLjLLBxA2gVpFLXY8Jz1Iyt6v+zcdL9lID5yOSTN+OZx8wjA+
         Jhww==
X-Gm-Message-State: AOAM5328u6pWDn92aWTdInY0q08lZ9NRi36+LJIjKftFmTxIBP1ULNrd
        LOwDXHSzUEtIjMG5ZVusMT1AZ71cYGBBg+XhVDZ43243JhSCWw==
X-Google-Smtp-Source: ABdhPJxEX3C0q6ga3rdCbtItwvoOsWDSpxLt++YGtTOkdlHeJP27dulf3Jmz7XeNV7OAQLgXeItWjRxmNtT7gDbl9Zk=
X-Received: by 2002:a05:6402:40d3:: with SMTP id z19mr19351146edb.185.1637724452475;
 Tue, 23 Nov 2021 19:27:32 -0800 (PST)
MIME-Version: 1.0
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
 <8cd3d258-91b8-c9b2-106c-01b577cc44d4@gmail.com> <CABVffEOMVbQ+MynbcNfD7KEA5Mwqdwm1YuOKgRWnpySboQSkSg@mail.gmail.com>
 <23555381-2bea-f63a-1715-a80edd3ee27f@gmail.com> <YXz0roPH+stjFygk@eldamar.lan>
 <CABVffEO4mBTuiLzvny1G1ocO7PvTpKYTCS5TO2fbaevu2TqdGQ@mail.gmail.com>
 <CABVffEMy+gWfkuEg4UOTZe3p_k0Ryxey921Hw2De8MyE=JafeA@mail.gmail.com>
 <f4f2ff29-abdd-b448-f58f-7ea99c35eb2b@kernel.dk> <ef299d5b-cc48-6c92-024d-27024b671fd3@kernel.dk>
 <CABVffEOpuViC9OyOuZg28sRfGK4GRc8cV0CnkOU2cM0RJyRhPw@mail.gmail.com>
 <e9b4d07e-d43d-9b3c-ac4c-f8b88bb987d4@kernel.dk> <1bd48c9b-c462-115c-d077-1b724d7e4d10@kernel.dk>
 <c6d6bffe-1770-c51d-11c6-c5483bde1766@kernel.dk> <bd7289c8-0b01-4fcf-e584-273d372f8343@kernel.dk>
 <6d0ca779-3111-bc5e-88c0-22a98a6974b8@kernel.dk> <281147cc-7da4-8e45-2d6f-3f7c2a2ca229@kernel.dk>
 <c92f97e5-1a38-e23f-f371-c00261cacb6d@kernel.dk> <CABVffEN0LzLyrHifysGNJKpc_Szn7qPO4xy7aKvg7LTNc-Fpng@mail.gmail.com>
 <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk>
In-Reply-To: <00d6e7ad-5430-4fca-7e26-0774c302be57@kernel.dk>
From:   Daniel Black <daniel@mariadb.org>
Date:   Wed, 24 Nov 2021 14:27:21 +1100
Message-ID: <CABVffEM79CZ+4SW0+yP0+NioMX=sHhooBCEfbhqs6G6hex2YwQ@mail.gmail.com>
Subject: Re: uring regression - lost write request
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 15, 2021 at 7:55 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/14/21 1:33 PM, Daniel Black wrote:
> > On Fri, Nov 12, 2021 at 10:44 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Alright, give this one a go if you can. Against -git, but will apply t=
o
> >> 5.15 as well.
> >
> >
> > Works. Thank you very much.
> >
> > https://jira.mariadb.org/browse/MDEV-26674?page=3Dcom.atlassian.jira.pl=
ugin.system.issuetabpanels:comment-tabpanel&focusedCommentId=3D205599#comme=
nt-205599
> >
> > Tested-by: Marko M=C3=A4kel=C3=A4 <marko.makela@mariadb.com>
>
> The patch is already upstream (and in the 5.15 stable queue), and I
> provided 5.14 patches too.

Jens,

I'm getting the same reproducer on 5.14.20
(https://bugzilla.redhat.com/show_bug.cgi?id=3D2018882#c3) though the
backport change logs indicate 5.14.19 has the patch.

Anything missing?

ext4 again (my mount is /dev/mapper/fedora_localhost--live-home on
/home type ext4 (rw,relatime,seclabel)).

previous container should work, thought a source option is there:

build deps: liburing-dev, bison, libevent-dev, ncurses-dev, c++
libraries/compiler

git clone --branch 10.6 --single-branch
https://github.com/MariaDB/server mariadb-server
(cd mariadb-server; git submodule update --init --recursive)
mkdir build-mariadb-server
cd build-mariadb-server
cmake -DPLUGIN_{MROONGA,ROCKSDB,CONNECT,SPIDER,SPHINX,S3,COLUMNSTORE}=3DNO
../mariadb-server
(ensure liburing userspace is picked up)
cmake --build . --parallel
mysql-test/mtr  --mysqld=3D--innodb_use_native_aio=3D1 --nowarnings
--parallel=3D4 --force encryption.innochecksum{,,,,,}

Adding to mtr: --mysqld=3D--innodb_io_capacity=3D50000
--mysqld=3D--innodb_io_capacity_max=3D90000 will probably trip this
quicker.


5.15.3 is good (https://jira.mariadb.org/browse/MDEV-26674?focusedCommentId=
=3D206787&page=3Dcom.atlassian.jira.plugin.system.issuetabpanels:comment-ta=
bpanel#comment-206787).
