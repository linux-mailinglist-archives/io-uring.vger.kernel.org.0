Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6D2576ABB
	for <lists+io-uring@lfdr.de>; Sat, 16 Jul 2022 01:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiGOXbp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 19:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiGOXbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 19:31:43 -0400
Received: from sonic302-28.consmr.mail.ne1.yahoo.com (sonic302-28.consmr.mail.ne1.yahoo.com [66.163.186.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5FA87F4D
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 16:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657927902; bh=ksyqXJMvpbT8p4D2cyd3UvJB/zcVEgkzeh0Qh2x/gv8=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=VgyUMik/HmWn/hL+XGYWkDk2uqTb8kKILiC85VeeVBqW5XR4j3QHhawynazHcORpQL2L52fVViqp3IR8mX1iU+JQSYEQKIriXR68MFa8UyUEbSdmSUe3eNnazoigtfH/fHleelzZOZyJDAmd1H4uh1VA0W7XuKmrWBp14UmeHxzm2BZRiy58Mh2tGC5qk9Jc0Oko5WvuKyZ7u8x/HYNIOcMA+Qd3D3AzuG5dTf86jFqoSs+QID7qKUPt8ZFfdbt5MwSEwairjttslvXbz6EmXLmRsBh6R8WFKNXbXcUZlTB2k+8PJxy3Mc3rTbHzUZpN7qBjhy9/FJnYppYpu+3shg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657927902; bh=jfz2nr8Frd/U44tGxjOnhPJcsbUga8QJsXKMj53WzUy=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=WR5ICP21kBgo9/IQQbW1KIM0RvFna2hdIZjRScvXOH/0TbqCenOrkElPHWbfpWx03OmDXB5ayaRSQRcNPQc4vwLdEtkvz0kj1STGhdLlbOaZj8vJeDrvYWoQPStbm0EDkKm2GHPcFBtLjV/7ZKziM22JnL0mM23YVqYSC2XeBkNKBQurnDPW0vIi0cbUPrWHG+LfhpN5CJzAm+k1KNDsSTMFcv6K2Mdj5TAzlc6LAh+vTSQQqWQjSpntEWtjE72jE07nh5Mr+h6EL8Tx7szJ1vK+Ty/YRU2S1nFGFLYTng+Ao66ZGSPo8wIgEzggd1AOugZXFXZ5B/5WDj8U/6rGcg==
X-YMail-OSG: O2WGldUVM1nxdYqsVsNJJOr6is23UGTu36jhAl0rZFReNMiXJwoNDQZW_G0qtNz
 azg7myLR1ZeRuO1qVmZwMd2BNVbPsGHJXVrfNhG7yeqF4IBXjhQqAvB7ycxuHQ_lMI_61vRgtMe3
 SHuuJNiHccwPidKN_oxvgbptLQPyW7Tzc_8IndirYX6HurVGbqRz_MpS0kCeYBkuy9Kr3E35Da0t
 YR6El3E6IJYxBmiAEfNYET.Anifm2ja1K44tBvSB11Nem7Xvay7hJA.vsVpeZznII4BAipe3sD39
 jsKU.PHKBTUjrtUOfQTTVLRDxz4uT.AZQ6UvAvcBj46CX65yzRzNIx0tWYFNHP5sPBhyRJKOL5LJ
 VDzedAo1w8dN7A26iqP3cewEVwimkXqmyqJAqbAoNBnTR7NpodUFIZqw_bJCyTFW.Dq9O_LqHENp
 eDFNCPl.kYqPVVy4QLA4dvelx_V7fV6hqjxYSXPy6quE.FuTimCJWllvmcebDGJZqFxEvp2.1j91
 AAevc7UMZ6XAi.b1Y5ifr2jBJW8UpBCYxsssJiLhSjuewNRycHyXhUNnw_FwGLm8v5iepn8Xbzhi
 Xy87YHC0IuqoDkm3k3PgiBU01FDj5YLqlTNGLJgRaJG2DJWkliEtnreRtd3qaXeuZf2WCeiAmHti
 OuUpSxfdb2I3fZAI6JgxbQFI.KOIetGVDDTDZxk6yQgao3_uMdXfQ0wRmzTCRPi.FZTLFwOfnhBh
 Zu0ifinZCNzWUmzH9R5752ah4bBsBs131KZXEQu_jN_YUxhAFG9TyTL7QmzH80RFL7sj2_AU4GPe
 eYHvUGO0gJ_Ho7Yxf2BkoInT_F42BbzO0_ICNNDZDGp37cenRdVdbRYO2T3z6phM7mDNDpLK6ymB
 yRhE0gg7QrAG3ZrLrvwZKVE3ddMPMBjU3JLCPrqRGZl4GhH4VB4PTSdyZjWzURmmgZ6m0rTNFO78
 Jel4uwF2CQ4LANDhlNkaHQgVCIQgZuv7wCV89d2A5LhYeJMz8O6yudaQ.1IGEIl53fJfT4bx9Dxt
 RzTM02LPfd6KKD.KxHyHWCp3a6k5J3z8VjNTqtPnNrIMHeICAlhe5YeuAar8EGgYvqUPpbvDY8RA
 d.faEgiH6qRTEr4joAmQdKNq671WCcPhIJ02vh7gXs0Vt5IY4Y2aBHfcoB_eQelltw_9JVHilDFp
 _KWLPHjme4uVmKKKiXBX1hEJlb3Sbif6Yxiy71jcVB7_nAWFyU4jMTZSBSTtc5nGqN7Kgfc.PaG4
 K4zYmHkicb8NnY6pckyNblQ4q.0OKO2Xzl2XlilzJa61O6Gfj2d7.jcphlD4fyV2jHoncZUrkN0L
 oOL.mwhYwqwTgBlTIfUJu6XTWBdhs5fqXAeU._eJyfuNhcrCQBnf_jpUQGTWT2rR3yXrb68d1_.D
 WA4D9kZ.htftGRHxa0TSh_EGLa0RwtD8ANg2lh4z02n_nyQ6IY9GTrSVj_JQk4wHA5NmcFFvolzi
 Odgwm7Qb_9wzU67Ms2rfXlbfkOyJ9BUkbfGFrau6TlADiUjZXzCAm9sax6iqC7Xz7DFpVcqVDQKF
 m.X4WfgHoYMz1Hxe3VBtGYVf8qZdDmVkDXVZY7RlUxDlEiWhgRLJqwsT7mWdlGe8XZ2yan7KhDe0
 D2h2B7q3wJhx.cymxlLCGerbfZFEY.uhH1M.o4r4K_qg.Qq0YS8WERjSZm1bPmx.FGhf_gcMewkh
 A.qt4dVwlsMnbB27FxWP355BuAYR7zGrLJD_kpi.i0v.a.5jXnxSx4WA3yN2GrxkAoUXLpGKSNsZ
 tFoy6_5u5bdycnjb85tZpZHkSbL8DKN8VU3LECpl1g49KphXs1bntwlXV.ytHyqZ83afEzs8OaEh
 G_gkI54n0_8.dCzIoR.jjOQ1ZPdXarwPu_311cuFhVJ25a6twaVVo0zDKjLbkW_4aVgSKxmJoqOD
 BV_x0dRMpbktG71U4fQiYqsEPMxFgM3uuhLXPApA.wMLEh8WQ1WOZh5P1yQAvAVbwcBskc.mTRXP
 8Heh8Sm6.OXVodd171GN1szJLgZiRVJiWLk50MP4cOk5WWxysHCaDyO_KSvo7cfccVTKXDWAXskt
 T8PGV6aP7KZhbjiKGniDWbm.DwSrnhh4I5bYeg1RBd8joEcUqAEjynGrtbLyqWoYGa7dMSOui6UM
 63IG630Fet_dzyb5Y8pOL3OpZgVlEKD_.ipvJHXVi_0Gaganmg1AbAwcWVFBmXyf35FGapiTccR0
 DoztL_tuCRmcRb4_A1gP2AjoxGP.8k_5IxBMH6rbrMQyR1crKmKaG_GOpwvWG24p5jLWmD4CaiGN
 IQyuV.HF2cNDY8G4JlY.kJQ--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 15 Jul 2022 23:31:42 +0000
Received: by hermes--production-gq1-56bb98dbc7-567k8 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID fdf2b8cd25fb47e9d5fadb2287b160a0;
          Fri, 15 Jul 2022 23:31:36 +0000 (UTC)
Message-ID: <5615235a-ccc4-efc7-c395-f50909860ab0@schaufler-ca.com>
Date:   Fri, 15 Jul 2022 16:31:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file
 op
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Paul Moore <paul@paul-moore.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
 <566af35b-cebb-20a4-99b8-93184f185491@schaufler-ca.com>
 <e9cd6c3a-0658-c770-e403-9329b8e9d841@schaufler-ca.com>
 <4588f798-54d6-311a-fcd2-0d0644829fc2@kernel.dk>
 <d8912809-ffeb-8d88-3b6b-fd30681ad898@schaufler-ca.com>
 <27b03030-3ee7-f795-169a-5c49de2f6dd2@kernel.dk>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <27b03030-3ee7-f795-169a-5c49de2f6dd2@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/2022 4:18 PM, Jens Axboe wrote:
> On 7/15/22 5:14 PM, Casey Schaufler wrote:
>> On 7/15/2022 4:05 PM, Jens Axboe wrote:
>>> On 7/15/22 5:03 PM, Casey Schaufler wrote:
>>>
>>>> There isn't (as of this writing) a file io_uring/uring_cmd.c in
>>>> Linus' tree. What tree does this patch apply to?
>>> It's the for-5.20 tree. See my reply to the v2 of the patch, including
>>> suggestions on how to stage it.
>> A URL for the io_uring tree would be REAL helpful.
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.20/io_uring

I'm sorry, I must be being extremely obtuse. I want to create the Smack
patch to go along with the patch under discussion. I would like to clone
the tree (with git clone <URL> ; git checkout <branch>) so I can build
the tree and then develop the code.  The URL you provided is a web front
end to the git tree, and does not provide the clone URL (that I can find).

>
> That's the pending 5.20 tree. But there's really nothing exciting there
> in terms of LSM etc, it's just that things have been broken up and
> aren't in one big file anymore.
>
