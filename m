Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609496BBDBE
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 21:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbjCOUD3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 16:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbjCOUD2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 16:03:28 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6321922C98;
        Wed, 15 Mar 2023 13:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1678910604; i=deller@gmx.de;
        bh=0gcAbjmoyUbTQFJIEHFPteSYbSNFp6PGgOBqOPCyuqI=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=crQ5xO5rNAdWNO+vBxviSIip3I50yh5li2znP/m07P4lxsZ9LDIQFpW2mMHJ4x1dx
         fFRevLXHgu/XZCtueQXmHabf3WdQnmiHx+sTbNidIa5ohxs7R3ckYaz6nuK02q79DE
         SwAYOczFfZN8hDd0InjFACVEYCJ+W4rzrqpZOmJlEy1TL02o5YTQ0JI2BgcRkxQxUn
         5+jH9BAagLFNW8JQJfMdUsSgi87M48ZBeyZijAHmO+yrvXbKyIFejAp341Zw9A4uCH
         rU2Pat6OB2hdWZWXh1yDKlcQ+QEJr7F1wXbk05qyEgXa2RDRvjWv4gTdO/CEAJOmLJ
         wfvG/ctMrQgmg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.153.118]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MS3mz-1q4uGW3oa3-00TV9K; Wed, 15
 Mar 2023 21:03:23 +0100
Message-ID: <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
Date:   Wed, 15 Mar 2023 21:03:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20230314171641.10542-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0aPUBC3XrylE4s79uGQLu+Vri39SuKubLLwM51ajyxY1kr27X2D
 IZhk8B9cU0tGCSSjD/pzOpGfIZ6jVFmYywiqe9F8AI0nLJuD0y/nxlQsrECYowLRp7m4ok/
 HAQbBVRVCysV8rn8ry7ykM2ED4u2HKc7x0dn07pORfRHBTg3ChxYDshop59LD1oI+LJUmqB
 Vs4Z22IA5LxaEvdN88JQA==
UI-OutboundReport: notjunk:1;M01:P0:FjCZ0ZcymU8=;MjBU6p/KsHTFt+mqWWmkcauz3dT
 nKUoHHa7Gk93Y4e1aECRLFbvlx2IRGjVHN/kNNqFr7GbdvFgSJjokpmyOjVOuNOtimBMEvKmA
 APKuL+1HRKUi94x/I5oPJc2qPtTZlkpGq72AZqiMpC/nP73Atajo/mX3xMuDmXw4UoAbTYNXG
 Ki/88/bpjCgG7ZIlBLgpyLooFN0oJoQD7w6Djhgq4ssrlE7DvoCoe84/cIyYO/AN6uqOpkXjz
 1yPx89WGDwGAgdIE9oyv+3VRvW7OlToQ6xu0PXcWDi6hPsjTpYO40PIiHf3X4jkDqdF/YmjtM
 4IeX2rfpWdKLA3lSR53zl+a11GIwGJsOBQctgCV3OEjy7ZltM2DDAeYKDDH36FBU/FQrQkstg
 C75sAILiH4l886chl7rsLW2gAH28J2h/fAMHik+Khx7TKPFb73txAa9KAY1zNt6It5b5mOTBL
 qkuEP4ykdgY6jOE3UWXmgNrnzT0sto2atistxRFz+rL/Uq5jEmOjhuiJ+NaqVMHQrn+/qDRc+
 vb17tSP1zI5FKl7jHGiWihx1jkWgjZTajffxvdikVbJIC9BVmblSaO0qbDNbwGMWIxtabDfU9
 PndpVPpVoODmlwcTHcHJZOm+eWC8q31QFdRB+cvIHkclL0G1g+dRronL/JC6HepiFHUzWUIEM
 HqXtxKQNX1mNX0iCydUGCBN+MgczxTIBNCbYvHdXQkimcHfyNixtgIysjFP6kLL0sejheVvkq
 lK9idItHxvUM8S/mbWYum0/T05l0ND1LHSM9NPAPBLk5JKpEk4E3wqbJBlxV6huYRlyw1WA3m
 iFju5ajqXLod/q44/2I4ujqPCrdPFKv93yuXyUOVsgfL2OThh6ozAskiC8/SAvyd+qVL28Yut
 bkgUxsYuVjiUymCTlMaFjR1nYK3ESz6jAhS8sMIBtnRG23LmsgYU0lbWQOsO1e6TPFqCHN09Z
 XK7297dL7G5gMmsKIDjIw0wxj+8=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

Thanks for doing those fixes!

On 3/14/23 18:16, Jens Axboe wrote:
> One issue that became apparent when running io_uring code on parisc is
> that for data shared between the application and the kernel, we must
> ensure that it's placed correctly to avoid aliasing issues that render
> it useless.
>
> The first patch in this series is from Helge, and ensures that the
> SQ/CQ rings are mapped appropriately. This makes io_uring actually work
> there.
>
> Patches 2..4 are prep patches for patch 5, which adds a variant of
> ring mapped provided buffers that have the kernel allocate the memory
> for them and the application mmap() it. This brings these mapped
> buffers in line with how the SQ/CQ rings are managed too.
>
> I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
> of which there is only parisc, or if SHMLBA setting archs (of which
> there are others) are impact to any degree as well...

It would be interesting to find out. I'd assume that other arches,
e.g. sparc, might have similiar issues.
Have you tested your patches on other arches as well?

Helge
