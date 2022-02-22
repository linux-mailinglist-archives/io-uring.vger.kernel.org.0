Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F324BF7FE
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 13:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiBVMWu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 07:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiBVMWu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 07:22:50 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE289AE61
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 04:22:23 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id bq11so15163683edb.2
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 04:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mariadb.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kCUY5M9zfyNllJKQootCA8Ykj6BLIeLc98Y0P2qCoNw=;
        b=k/XiLr19YXdLjfiQouhgNLSBgGsCFjSlKP5gbWfEySv54fJgL4LKxkWUq9AOanHuoZ
         ZgWqfzbcqxcwr896otMHYIUBBaIBeHiJfoxXSIkKCrdsajAXiD60+gZHFLaXwlcbeyub
         BBBXTXncnP+xuINOcgfTpAL8nXK9mfK2fxpdFtZurVh7qoDrtwdokAormsaEKCyos7kw
         K/7SFbs29Ex/WV4YURVQYZisCjNWYApUsMx0/1RMadEgt5Iu8JnD0Hdnkiqr72pbNHQ3
         HNvRpnsk9s9lKm2y0HJJ25Ffoy97lIocCiLAp9EAM3MGpAbTBSXMME1lXz1YQHPL1sxp
         ZNJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kCUY5M9zfyNllJKQootCA8Ykj6BLIeLc98Y0P2qCoNw=;
        b=S6THqzfifibrUuwdWTuFzUS7O1Dq7r/E9/5so9ECIKxfo6+/uDC7iW1k9goAX1ctUd
         qQqRTFtnCWBSr8UWlvgH/9d3dY9cy5t9TvynypjJ7AniypLD0sz77TcT5GUoaj4/QBLU
         IhnwYzwh5zO4T/AGQeqdffg8XFSYzsW8OV9YLk0r4IoK/w1iTBXPnWNqMiFsTIW0nfpX
         iAXoB8JzqShU0Bwyi8h5Vtca/+ObpLucNxopJiWQ2gY/Imu1f1lM9Me1o7KztYY9su6u
         h36q76lNSSy+pA5o1RvalKLpR2uSCjtTRXuPENrylaYAapk7Xnx7ygpXMYTlskj9N1mA
         kkBA==
X-Gm-Message-State: AOAM530HzRSg+Kgr2dd6/FXIXndu/94/cOkb9W5aBtWGW/StjxYdUO0+
        8LhLjGvZCuup4sDv5hg9qrLtcDidcY0TJsfa8v13xv0hGCI5rw==
X-Google-Smtp-Source: ABdhPJx5n2Bk/SI2h2RwpqTa/3yCCKXdp5Eg2ZXQdT1HE4MPLwo0I+wq/Ffvngm8Y+3BfzlBZ0wFsU124jUK6YYeeKA=
X-Received: by 2002:a50:c048:0:b0:410:a2e6:eb66 with SMTP id
 u8-20020a50c048000000b00410a2e6eb66mr26698727edd.156.1645532542294; Tue, 22
 Feb 2022 04:22:22 -0800 (PST)
MIME-Version: 1.0
References: <CABVffEM0eEWho+206m470rtM0d9J8ue85TtR-A_oVTuGLWFicA@mail.gmail.com>
 <CABVffEO3DZTtTNdjkwTegxNPTHbeM-PBeKk5B_dFXdsTvL2wFg@mail.gmail.com> <YhTMBFrZeEvROh0C@debian9.Home>
In-Reply-To: <YhTMBFrZeEvROh0C@debian9.Home>
From:   Daniel Black <daniel@mariadb.org>
Date:   Tue, 22 Feb 2022 23:22:11 +1100
Message-ID: <CABVffENr6xfB=ujMhMEVywbuzo8kYTSVzym1ctCbZOPipVCpHg@mail.gmail.com>
Subject: Re: Fwd: btrfs / io-uring corrupting reads
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 22, 2022 at 10:42 PM Filipe Manana <fdmanana@kernel.org> wrote:

> I gave it a try, but it fails setting up io_uring:
>
> 2022-02-22 11:27:13 0 [Note] mysqld: O_TMPFILE is not supported on /tmp (disabling future attempts)
> 2022-02-22 11:27:13 0 [Warning] mysqld: io_uring_queue_init() failed with errno 1
> 2022-02-22 11:27:13 0 [Warning] InnoDB: liburing disabled: falling back to innodb_use_native_aio=OFF
> 2022-02-22 11:27:13 0 [Note] InnoDB: Initializing buffer pool, total size = 134217728, chunk size = 134217728
> 2022-02-22 11:27:13 0 [Note] InnoDB: Completed initialization of buffer pool
>
> So that's why it doesn't fail here, as it fallbacks to no aio mode.

error 1 is EPERM. Seems it needs --privileged on the container startup
as a podman argument (before the image name). Sorry I missed that

> Any idea why it's failing to setup io_uring?
>
> I have the liburing2 and liburing-dev packages installed on debian, and
> tried with a 5.17-rc4 kernel.

Taking https://packages.debian.org/bookworm/mariadb-server-core-10.6 package:

mariadb-install-db --no-defaults --datadir=/empty/btrfs/path
--innodb-use-native-aio=0

mariadbd --no-defaults --datadir=/empty/btrfs/path --innodb-use-native-aio=1

should achieve the same thing.
