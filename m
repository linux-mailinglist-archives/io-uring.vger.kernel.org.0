Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E84C462AF4
	for <lists+io-uring@lfdr.de>; Tue, 30 Nov 2021 04:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbhK3DT0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 22:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhK3DT0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 22:19:26 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE368C061574
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 19:16:07 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so17185497pja.1
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 19:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20210112.gappssmtp.com; s=20210112;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=Ep//I6X9EwMOGytIk2LJyc0T6Seun3W9bS4GLy6K+q8=;
        b=6Ubv2vwWNyYvHVzGJKIRt3A/47QW7sjw5tA2fZiehQIJet0lDwox0ToKSRIuZ46QPG
         KUgP5XJ+XkDpeLrEnRl+P3TQuj7VJ8eOSeqMqinVuh4JW4N0rF4rmCjk6mbWxy8gSAVl
         XT9SGQLQp1StbBtT0go3vxE+POHfAUI5The5hMG2e110PrjSrfvWoCiTKfPAQM+DA6/u
         +3cHdHX4qVwXm+8oaoaoHD+XsbBtOE68SWjaJFmtWsuONyhpvr7gtS05X8vs/6snnpIn
         IqYjqpwJ4oATCzl3AFcNgL5VPZxIf5YC5OcToSfrp65SrKhA3m/51p1S64S/qBCPfSbY
         6Vzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=Ep//I6X9EwMOGytIk2LJyc0T6Seun3W9bS4GLy6K+q8=;
        b=Sk9aRMV1AQwjiQRz5T2BiaZ/Z7YacnDb5cxaJBIwCZfohMLGt+dUaeIqXlVY2vkEZE
         lfjX7tREvcnE/Jazlr6S+qNMOJ0k/QkUjJ4H4a2Lh4e4h86Jw/pkzYlgQ9WBrLFGk1/K
         dmi7DXX0ySQ7jBCJszSuXyMaxujP4rXjAI1yR8mpvtCr+7CaVlrES/UKE1nFZpoINVuA
         mO3DEjxmgxM0S//w4CwoDd4/siI2Kk03mZnolTxtYZ7Fl8RBF3cV7cOaXP1BGCyqB+lM
         vNKOY2Dna0nXLfZBsRA7ca5jVV+82MNmRxLUuTmZK/yMqtgbWDKJ4zBNlTe31RStn5a+
         kl9Q==
X-Gm-Message-State: AOAM533udPMOtsHfxqdRxa0ObdWXYx43kv52uGYCU+GSnnmMZAuv/om5
        alo4Y+RYXghqGMwfaQ3wjwZyDw==
X-Google-Smtp-Source: ABdhPJyxCMUbz0YcvI0ge2tGOajb1hrg8/M4heanJtM+148OnbWFl8Zsz0uIzflJX5tCqPFt7peZkA==
X-Received: by 2002:a17:902:b70b:b0:143:74b1:7e3b with SMTP id d11-20020a170902b70b00b0014374b17e3bmr65563621pls.26.1638242167227;
        Mon, 29 Nov 2021 19:16:07 -0800 (PST)
Received: from cabot.adilger.int (S01061cabc081bf83.cg.shawcable.net. [70.77.221.9])
        by smtp.gmail.com with ESMTPSA id z16sm13564864pgl.29.2021.11.29.19.16.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Nov 2021 19:16:06 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <6A6C8E58-BCFD-46E8-9AF7-B6635D959CB6@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_890933BE-DA95-4DA1-975D-89DFA1B995F3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Date:   Mon, 29 Nov 2021 20:16:02 -0700
In-Reply-To: <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To:     Clay Harris <bugs@claycon.org>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
X-Mailer: Apple Mail (2.3273)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--Apple-Mail=_890933BE-DA95-4DA1-975D-89DFA1B995F3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Nov 29, 2021, at 6:08 PM, Clay Harris <bugs@claycon.org> wrote:
> 
> On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:
> 
>> This adds the xattr support to io_uring. The intent is to have a more
>> complete support for file operations in io_uring.
>> 
>> This change adds support for the following functions to io_uring:
>> - fgetxattr
>> - fsetxattr
>> - getxattr
>> - setxattr
> 
> You may wish to consider the following.
> 
> Patching for these functions makes for an excellent opportunity
> to provide a better interface.  Rather than implement fXetattr
> at all, you could enable io_uring to use functions like:
> 
> int Xetxattr(int dfd, const char *path, const char *name,
> 	[const] void *value, size_t size, int flags);

This would naturally be named "...xattrat()"?

> Not only does this simplify the io_uring interface down to two
> functions, but modernizes and fixes a deficit in usability.
> In terms of io_uring, this is just changing internal interfaces.

Even better would be the ability to get/set an array of xattrs in
one call, to avoid repeated path lookups in the common case of
handling multiple xattrs on a single file.

> Although unnecessary for io_uring, it would be nice to at least
> consider what parts of this code could be leveraged for future
> Xetxattr2 syscalls.

> 
>> Patch 1: fs: make user_path_at_empty() take a struct filename
>>  The user_path_at_empty filename parameter has been changed
>>  from a const char user pointer to a filename struct. io_uring
>>  operates on filenames.
>>  In addition also the functions that call user_path_at_empty
>>  in namei.c and stat.c have been modified for this change.
>> 
>> Patch 2: fs: split off setxattr_setup function from setxattr
>>  Split off the setup part of the setxattr function
>> 
>> Patch 3: fs: split off the vfs_getxattr from getxattr
>>  Split of the vfs_getxattr part from getxattr. This will
>>  allow to invoke it from io_uring.
>> 
>> Patch 4: io_uring: add fsetxattr and setxattr support
>>  This adds new functions to support the fsetxattr and setxattr
>>  functions.
>> 
>> Patch 5: io_uring: add fgetxattr and getxattr support
>>  This adds new functions to support the fgetxattr and getxattr
>>  functions.
>> 
>> 
>> There are two additional patches:
>>  liburing: Add support for xattr api's.
>>            This also includes the tests for the new code.
>>  xfstests: Add support for io_uring xattr support.
>> 
>> 
>> Stefan Roesch (5):
>>  fs: make user_path_at_empty() take a struct filename
>>  fs: split off setxattr_setup function from setxattr
>>  fs: split off the vfs_getxattr from getxattr
>>  io_uring: add fsetxattr and setxattr support
>>  io_uring: add fgetxattr and getxattr support
>> 
>> fs/internal.h                 |  23 +++
>> fs/io_uring.c                 | 325 ++++++++++++++++++++++++++++++++++
>> fs/namei.c                    |   5 +-
>> fs/stat.c                     |   7 +-
>> fs/xattr.c                    | 114 +++++++-----
>> include/linux/namei.h         |   4 +-
>> include/uapi/linux/io_uring.h |   8 +-
>> 7 files changed, 439 insertions(+), 47 deletions(-)
>> 
>> 
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> base-commit: c2626d30f312afc341158e07bf088f5a23b4eeeb
>> --
>> 2.30.2


Cheers, Andreas






--Apple-Mail=_890933BE-DA95-4DA1-975D-89DFA1B995F3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAmGll3IACgkQcqXauRfM
H+Dzuw/9F6bra0aF+gZWjaOYzE6aARhHzHEHQGSzX5dYMS1YoWxQuB5OEhRaKCQq
zXPAtgkLbLA5RoBclJ8hZQNiusAtztTJfPJmfjOesU+4Zn0ryFoEeYHdxulHt+wI
Je73cs3RRjErAdk1LaN8bUJ5aDM2KJOYVSewYwOaBGQ/W5QAPXHU9ZL+K3Zk7MCn
gecCOjTOmXOLZAlX3hskYI7vfCB+Xb5NKchvXzcc0LvZ+Skf2xBwVdOXaXisGSpi
uGI3H9sHh3uIHI1X6JOrdUbtnLzflyqIX7ljvR/YfrInpnA4ao85gBMi4YL3FwuS
A9wYw0hZ+3dOhsOkalAz8cZmiAjAP7tos3rQLKX2t2cnqXwRv0vM/xA/XNpCbAmi
GQFtW6vsuYt0uEWhInNHueni8j2khVivGv6tzl7h2h9/ZLbGmXL/hMQdIG3YzZkF
j0HwjDm9Yj+eIh1Lhn+83xcBUXSLeQp1IP6AKm+rZWBKGQKP9PWnCZt/C0gjYwc8
z6Mwuiai3LaJD1lCpEXi1+cOnxEn1ewyI2KXcz1Fl94UYISgTcm4C/qZxWrY7rff
VZED9UyTLFa9y6sEWL5j4god6DWvy913PJ54pDmQdqoTQAJT/NOMPPbNLgUiCf2f
l/ww3CjAxHUNt6aVGZ6DkzQ9j3S1E5UELaxUjbKkw17U03X54X4=
=GM8G
-----END PGP SIGNATURE-----

--Apple-Mail=_890933BE-DA95-4DA1-975D-89DFA1B995F3--
