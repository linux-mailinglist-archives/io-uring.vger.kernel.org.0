Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA514E52D8
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 14:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243354AbiCWNNn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 09:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244181AbiCWNNm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 09:13:42 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D727CDE7
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 06:12:12 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id r13so2052134wrr.9
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 06:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=G6VWRq8MCkwpBSfGGK98F1PWW3UedbEzccmYbcoDmZY=;
        b=geTL+Bi9zESMAaPjO7ORBpxwU+WIhJ11aSz4NIY/iZCarSuUYMO4AUVK4trfEovSwV
         UF0cbacAj2yNqu1z/jupgPALV7y3gIFiL9ntFxLPPDAw1zzBlM7OfNaTFfK1Yu6SpHE5
         LGG+JvePfJyUl9y5RgQlw/veiiG0AhKGJ45QviIZhcDo+kqUoMvrOCfUWWSQ8dy++7Ga
         QjCdIC+YYhH51He6JBZ92mrnr9E/ZFBC2DSmqqp8FatrEmPVNPaBbdlYz5gHMnaFduU5
         +HiHr+1yao+ISAw50BHGTqu2lr1C618snUFz6J6Ff5eeEoAs+LHouQiDyDi51vW1DL4G
         kjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=G6VWRq8MCkwpBSfGGK98F1PWW3UedbEzccmYbcoDmZY=;
        b=CMLkqU1TKGSQkxL540q6AtQRws3kgFmmcKoXtmctccrnRVZur6UcB7AnaDqYtZH914
         9UqlFcot2kbg1Dk6LBY/7Dgx97GwnvflQabUftjQWoOK8ESdknIqUFviC63eNSuw9IvD
         MsEGWnHo28+FnCVfl5ppNWLYkzINSP76QEavfZBtq2Ww5KkT39GKOlHPG5dHtMUueZC5
         fMToIac+aiLlnL36elXjIo334SzMSBfu+P9tpLFkHnCfaMxnTTM7SzKI2jXjg4FGGZTF
         V3mYaIMXHefiUQ4igv/9vcUjdC+EMlqejySISsWkRNcTL0nWEO1EPweHNAav8nuTuPIw
         LBxw==
X-Gm-Message-State: AOAM533oiXHtYgLeyj4wZMiC6zFwiwAGE1VLVDtlA8RRiU8wL0ooZdwj
        SgoUO1ELpxWmx/JNhYRNQLYbkEuwDWbtsyfGcRGt1QMm
X-Google-Smtp-Source: ABdhPJzUn/k62LlxE2I+H4jaPBezZ/LdWmPQkQ2Mq2Q1uMRHNj+NGxZqfsGAtwvWBoKlicT5F+e3Y7YlO6ITTj+D0IE=
X-Received: by 2002:a5d:526d:0:b0:203:d69f:3a66 with SMTP id
 l13-20020a5d526d000000b00203d69f3a66mr26985560wrc.74.1648041131085; Wed, 23
 Mar 2022 06:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <BYAPR15MB260078EC747F0F0183D1BB1BFA189@BYAPR15MB2600.namprd15.prod.outlook.com>
 <7e6f6467-6ac2-3926-9d7b-09f52f751481@kernel.dk> <DM6PR15MB2603FB4275378379A6010323FA189@DM6PR15MB2603.namprd15.prod.outlook.com>
 <DM6PR15MB2603162E692B5A68A4FD0A6FFA189@DM6PR15MB2603.namprd15.prod.outlook.com>
In-Reply-To: <DM6PR15MB2603162E692B5A68A4FD0A6FFA189@DM6PR15MB2603.namprd15.prod.outlook.com>
From:   Constantine Gavrilov <constantine.gavrilov@gmail.com>
Date:   Wed, 23 Mar 2022 15:12:00 +0200
Message-ID: <CAAL3td2kwj4Gf-q1zpVUpSgNKFKwXq0biuu7TF6um8ZAQaQo2Q@mail.gmail.com>
Subject: Re: Re: io_uring_enter() with opcode IORING_OP_RECV ignores
 MSG_WAITALL in msg_flags
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> From: Jens Axboe <axboe@kernel.dk>
> Sent: Wednesday, March 23, 2022 14:19
> To: Constantine Gavrilov <CONSTG@il.ibm.com>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> Cc: io-uring <io-uring@vger.kernel.org>
> Subject: [EXTERNAL] Re: io_uring_enter() with opcode IORING_OP_RECV ignores MSG_WAITALL in msg_flags
>
> On 3/23/22 4:31 AM, Constantine Gavrilov wrote:
> > I get partial receives on TCP socket, even though I specify
> > MSG_WAITALL with IORING_OP_RECV opcode. Looking at tcpdump in
> > wireshark, I see entire reassambled packet (+4k), so it is not a
> > disconnect. The MTU is smaller than 4k.
> >
> > From the mailing list history, looks like this was discussed before
> > and it seems the fix was supposed to be in. Can someone clarify the
> > expected behavior?
> >
> > I do not think rsvmsg() has this issue.
>
> Do you have a test case? I added the io-uring list, that's the
> appropriate forum for this kind of discussion.
>
> --
> Jens Axboe

Yes, I have a real test case. I cannot share it vebratim, but with a
little effort I believe I can come with a simple code of
client/server.

It seems the issue shall be directly seen from the implementation, but
if it is not so, I will provide a sample code.

Forgot to mention that the issue is seen of Fedora kernel version
5.16.12-200.fc35.x86_64.

--
It seems the issue shall be directly seen from the implementation, but
if it is not so, I will provide a sample code.

Forgot to mention that the issue is seen of Fedora kernel version
5.16.12-200.fc35.x86_64.



-- 
----------------------------------------
Constantine Gavrilov
Storage Architect
Master Inventor
Tel-Aviv IBM Storage Lab
1 Azrieli Center, Tel-Aviv
----------------------------------------
