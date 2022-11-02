Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BAD615D57
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 09:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiKBIGq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 04:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiKBIGo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 04:06:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150292792B;
        Wed,  2 Nov 2022 01:06:41 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 4so15871410pli.0;
        Wed, 02 Nov 2022 01:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:in-reply-to:references
         :thread-topic:message-id:cc:to:from:subject:date:user-agent:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GLszQCumZWqrTfvpFmiT1zAxxk2ej2c9UMZ+mNXeV94=;
        b=Moi7dpk1LJeUfxV0DdqXgPkpq5kb5nYev7rVzmpwpkmLq4SV8METyZ8EDaFUa8Bc/u
         oAuYb9WSEL4oFHSRATMeGK8R/gDkEla+oHGEgC485GLTkPxkQWukERCuUFQBOLipzj7u
         7uykdoRmOVafFQh6o4lwtapbJeAMaEa2EHs0kxSA6JsOUrmonUiOxnW46WW5AkPT+GyX
         6C9K9uzDTEsQ+ThBO3VsnWi4lGd2xx5pdVrviOMBZgLCuclSvVaxqefSX2o985BbM7r7
         o9eMrzDOLEmCqul0QCJDd+WO5qtQqy9n3F1E62DD8u1pmqxxHuws6CKuMi/UBNNIWDBW
         xpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:in-reply-to:references
         :thread-topic:message-id:cc:to:from:subject:date:user-agent
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GLszQCumZWqrTfvpFmiT1zAxxk2ej2c9UMZ+mNXeV94=;
        b=xq0t5k64+pyLVmtP2oU6ghmdmPLX8Gb6/a5RrYQxMXxkWjHrDHqN+47b1sGw8VUmY6
         e2/VE+rU9oHGM4ZJOQ4YII9zzpT1jkI7Dk/Q3qvSZPx9mxkrN9VwLsPrjS/HEkunHmEF
         ifd93efJPlc62TTAhKWuXr0txKwoTwT8Ojlw3GBpfs+fHhPY8Q8fXdC94yaQEYGsfhwD
         kxFS/62jpdyZ4P5feQ7jgKUC7yMbHTmqtMIBOCimSdelCr2tJq5D2gEB/YYfKDTKQ1BQ
         8X2Vm8Fng/X+nLzdkdIG10063QcyQng8J3J36mj1mzhd4rGU+hGE3PkbjNRC0wnC8MHq
         Gssg==
X-Gm-Message-State: ACrzQf0e9iePODHia2UkAo5odb2YY/5c0fyj0O6naAUSLynuWHRr5mM+
        71WItodCPhpwmi0nK7CX43+mdigW6y9L6+tz
X-Google-Smtp-Source: AMsMyM5ApROJteN8GCkjXAcHHCSwo5JHewXdkxfieJTf035q106jCFJaP/DWZiC1p14+TbUXQiBG9A==
X-Received: by 2002:a17:90a:2f88:b0:213:f498:eb63 with SMTP id t8-20020a17090a2f8800b00213f498eb63mr12350187pjd.232.1667376400471;
        Wed, 02 Nov 2022 01:06:40 -0700 (PDT)
Received: from [30.20.53.44] ([203.205.141.83])
        by smtp.gmail.com with ESMTPSA id a19-20020aa795b3000000b005636326fdbfsm7827431pfk.78.2022.11.02.01.06.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Nov 2022 01:06:40 -0700 (PDT)
User-Agent: Microsoft-MacOutlook/16.66.22102801
Date:   Wed, 02 Nov 2022 16:06:37 +0800
Subject: Re: [PATCH] io_uring: fix two assignments in if conditions
From:   Xinghui Li <korantwork@gmail.com>
To:     kernel test robot <lkp@intel.com>, <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
        <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <F8C3CD1A-A2C0-4772-8AB6-2F2ED04A9F76@gmail.com>
Thread-Topic: [PATCH] io_uring: fix two assignments in if conditions
References: <20221101072956.13028-1-korantwork@gmail.com>
 <202211012335.tCnMjA6q-lkp@intel.com>
In-Reply-To: <202211012335.tCnMjA6q-lkp@intel.com>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_QP_LONG_LINE,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



=EF=BB=BF=E5=9C=A8 2022/11/1 23:10=EF=BC=8C=E2=80=9Ckernel test robot=E2=80=9D<lkp@intel.com> =E5=86=99=E5=85=A5:

>    Hi,
>
>    Thank you for the patch! Perhaps something to improve:
>
>	......
>    If you fix the issue, kindly add following tag where applicable
>    | Reported-by: kernel test robot <lkp@intel.com>
>
>    All warnings (new ones prefixed by >>):
>
>    >> io_uring/poll.c:601:7: warning: variable 'apoll' is used uninitiali=
zed whenever 'if' condition is false [-Wsometimes-uninitialized]
>                       if (entry !=3D NULL)
>                           ^~~~~~~~~~~~~
>       io_uring/poll.c:608:2: note: uninitialized use occurs here
>               apoll->double_poll =3D NULL;
>               ^~~~~
>       io_uring/poll.c:601:3: note: remove the 'if' if its condition is al=
ways true
>                       if (entry !=3D NULL)
>                       ^~~~~~~~~~~~~~~~~~
>       io_uring/poll.c:594:26: note: initialize the variable 'apoll' to si=
lence this warning
>               struct async_poll *apoll;
>                                       ^
>                                        =3D NULL
>       1 warning generated.=20
>
>
>    vim +601 io_uring/poll.c
>
It is do a problem, I will sent v2.
Thanks a lot!
    --=20
    0-DAY CI Kernel Test Service
    https://01.org/lkp


