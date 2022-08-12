Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED7F59099B
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 02:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiHLAnd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 20:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiHLAnd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 20:43:33 -0400
Received: from sonic309-28.consmr.mail.ne1.yahoo.com (sonic309-28.consmr.mail.ne1.yahoo.com [66.163.184.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E75A1D2D
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 17:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1660265011; bh=NvCgpQ/YO4vsuO6hROLvQifbF5utBdvYNOiB9BcZWIE=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=YAGzKPndZ0aMXhHA35/H+4z5NAsoGQcOL4i6sqcCorEL52UrTivwwnmUEEqcUd3N17PONonSP79QIOcXQmp4CqYFYYIHRyEAQNKA423WTPBdBLDFa5VwhCJlyozssfX4pojj1FrH0dbzxEN1QGeqZWUKVKkEodFp6zEBUZo+EGC6m28VFbCChHSCAYr7NRVd0d61bRZ9N3OMo+zBx1Q8pjkWw131N/gXZ9qBBvQAC01ErtKkspJFckqdXb0U7Q/4VCGUaurxCk94LMwonkHoEWxu9AY8Bw094GerooMYo5//Q47mI8HhLcCN5XuxgkBmP91ts0PK/Cr64sV2YmCw5Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1660265011; bh=x9218huSNloZBuSV38/2U2fdary5etQny5xdbNjVPG3=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=O+pMkTLJILen1LuRkqEC9q/h0PTm8aXhVus0yXHRfX+9ZW4DqZDbygXGha+CRAzMSYSQHZe9WnvUuPXVCD6MLvhxILAT5aoirc5d2yNMiD3ok7y+lK0UN4+oAMQLbfGratA9xD/CS26xKgkW5nG0BdPQVeyhKFjLwsWh3XXHOJR9YVhKvjqCXdaSMZAejxsbIBYt+15xmGYwjj7r3Ep6Lnv9oQxhvjy+130SqDC0pWIR/97nXwEn7ZARBuKfpycU0jHczMirFRpIT1p3oMJV0rhIAqox6p6hdUcp6Ki8HcvgD42AChx+vDat8r3uz5/Fb9iWdAr+W/b2E+mlsR3ICw==
X-YMail-OSG: CqfXXHAVM1nuR1o8bcpdSYId59_fcWKdXsvE_oKff1Ah6DEM7guD.CxXl4Xe9Wq
 Is7gNAM_5nIOQkNQ.PvLDZWIyQyTfj12I8le3amoNrcXSM.TFUolh2wFgMsUrse.UMTtPiCrcEzQ
 QI3SIHqDRB3l2LPVliwjuYUrigmMtd.DMA9ws2aNYA8TsntyaptvjT74wbDgcORF7BZ5UOnX56Ad
 yUcNERTk49n6xnt.KhiLpsSJHJUvMCvmmQGGQMU73N8WDU3vlFio0vgAmrTcnzJwr2rr9x8O_1O6
 NH7R1fCpfUvr_miXKa4gHV7P_qrxCWhbyvom3z_NNCVUmUUka_wSu2v4bijfv3pJFep47meCJcjg
 sj3Asmz6p_Nkh2uoLa1_YXg4aYv8r72r_PjPjXq2sqPgo9btS7mQNS1lf6i6pRFd6RarCnOvbeE_
 wq_nf.PrD2_XwNskaoYIRGeuQKgf66eS0ON7zimvrmD2619J4_n1Wenyc3MhUccFp3RbrEta1WJZ
 veNJL1Jg7MWWTkTOjvmqPCxatR0BhDcdTDBbPJtqEGpJiGZV0ZagznQu6Wr2LfqYiiqR3l4Y704l
 4kCzpptJqcCXhZ2K6Uwn9tnhkUtYtfY6NxYnmmxRVdCPpsrkuPwfZbfoN8gTxIANHhp7dq1ZwYKn
 4TQ8d2bmXO_m6Tn5McMscipZl7.dEriV0.hvb6dx0H3lRDB.oR8sI8iyuh21o1.QBPHE6OuJC6Nb
 xynNg_fxw28mi_D3GZAQQl4T42z6CLHGFmwGMVgJe80WbC15InaUkmGlncQe8YSVLfkOOC4ZOq4L
 9BFg65ueFidh5QBR6Kg7tdAX0WumVHPlWRDGQxBCaVc89LSRD_6iUwpOR8TPSBB4O2.F3hARrZ2J
 UIYi1gw65RNacIqhf2_7iAlcvHsGzw33OschMOKrzpsgYqge.34_qandzCFJe9fyTZ47BAmn35PV
 kAHZHpgQBKjDntyjfv4_4v9y4GaRQjRBrFY0GbJ1l5d3jpIyif2j1xFC90Vk3UXWGiKDr9kHCKnq
 HtSTXBfT8VmvGOXi3MGIGTf.ZAT7b8eKziSgKI7QkYitjBZpsRiSd5z7uOEs.X.Eh8JHm3W5clLU
 BYe69wV5Tnzlx.JG0bk7ERc.0GFrSmilvZsAz6moxgY1LlCpm482vi_XdNY3o1C.KP_Mt3_hCRHj
 O2HCyh8xFbpPcO6h9xC7QBVo2AKhvFV1XxIS7hvpx_NOLYx3L.SMWG5w30eTNLg5PI0ocVvN.Xvs
 GrI2XLXU3ujlWdcE9H_e1WW1eV4pFnfOqZca.DLMmVTtYaDIvsPEx8xMeXVr7JxetBdh7p8Nk9IV
 yIX9.3ovz.yRpVpyEgI0FN0t7VsecgtaAW.Sdsky1XEY7A2VES1_eIVl_SYW4Apw30XbCdn09ERE
 airuNEcJrEtr.Rmcr9GA8vBmF6i94s5E5CNu6wqlGoX25wpLKI0fYetSl043aEIc7zsy0l.vxNQ7
 aQjC8oOKeAS5HaMYk05l3O.2.OyS6ASHsiE9P9fpWPh2SQlZU.FdbyliDuEERegMxVKShbisGyHm
 PYumctLXgEdL4oOsTi3XL3EZGm2mIc4tQfap4sYOKwRpve.OhbYf2iv4Fb4l2EIGdpHbTnLb43t7
 lYYc4d8X4NcYOVAm8akFtszRAhIaqfCGuqFH_PwIhu8giDcokdMgJIiKDrZT69jw2HCcsaXsz3Oi
 TJrtxoD_sHZ4DbXp5h.cdvOw6k3FuNKqvbJvyv5pZsXrCFQ7XzDkPM.q0He1Pu3Cq1RRp9.ZriC9
 0PRv8nz1epIK_hb2tGMkAdiSHvDHUDMM6UOS3STVzsG61L1r2h2snDRL.1l6bpObPu6geXYDffED
 .y3cMqUX3pkfUMxrQVd3Jg0MfcKr.1lzoL5oXvMx53E0mFVC8MWnBTlFKoW_AQVk_wBcWkY1zbQs
 LGf9Svdd5OjJTE5B0v5C.Ak_.Im5NIjkuYYr1tpdR0D5YyZ.d3kXz7sHD22m6a4CwiAJ8EIK44d9
 3l.gm7YjMfwwwXv62FwGFvm76aSgl5Bs2uz2qmHZndy1Skq8Zm5U_wF6RdS4Hd.Vh9IwLxfRvt8x
 Lm420dpVSBXfXiCHEm3YUcBcZg8C4OvjXo_K_d01O22aYfzspYNsse5kMGz4QRHbqGVKrqDiryty
 0W8rL1gFzwRHFOXHhKSJOJvlTxB8JUZCUays2gph93UGSI_zwZjsAFf44c4ik5PSN8PWrkyAsh5K
 sTIZerkuy_3Yi048j1c5owbTZGl1jDXhOjjDMVoX9LtyjWY0A6Ds-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Fri, 12 Aug 2022 00:43:31 +0000
Received: by hermes--production-bf1-7586675c46-b9v2k (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 7db8b521cae2502dc511b68ab538b59f;
          Fri, 12 Aug 2022 00:43:28 +0000 (UTC)
Message-ID: <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
Date:   Thu, 11 Aug 2022 17:43:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH liburing 0/5] Add basic test for nvme uring passthrough
 commands
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, paul@paul-moore.com, joshi.k@samsung.com,
        casey@schaufler-ca.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20220719135234.14039-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20531 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/19/2022 6:52 AM, Ankit Kumar wrote:
> This patchset adds test/io_uring_passthrough.c to submit uring passthrough
> commands to nvme-ns character device. The uring passthrough was introduced
> with 5.19 io_uring.
>
> To send nvme uring passthrough commands we require helpers to fetch NVMe
> char device (/dev/ngXnY) specific fields such as namespace id, lba size.

There wouldn't be a way to run these tests using a more general
configuration, would there? I spent way too much time trying to
coax my systems into pretending it has this device.

>
> How to run:
> ./test/io_uring_passthrough.t /dev/ng0n1
>
> This covers basic write/read with verify for sqthread poll,
> vectored / nonvectored and fixed IO buffers, which can be easily extended
> in future.
>
> Ankit Kumar (5):
>   configure: check for nvme uring command support
>   io_uring.h: sync sqe entry with 5.20 io_uring
>   nvme: add nvme opcodes, structures and helper functions
>   test: add io_uring passthrough test
>   test/io_uring_passthrough: add test case for poll IO
>
>  configure                       |  20 ++
>  src/include/liburing/io_uring.h |  17 +-
>  test/Makefile                   |   1 +
>  test/io_uring_passthrough.c     | 395 ++++++++++++++++++++++++++++++++
>  test/nvme.h                     | 168 ++++++++++++++
>  5 files changed, 599 insertions(+), 2 deletions(-)
>  create mode 100644 test/io_uring_passthrough.c
>  create mode 100644 test/nvme.h
>
