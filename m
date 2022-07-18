Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E16578822
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 19:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiGRRMo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 13:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiGRRMn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 13:12:43 -0400
Received: from sonic308-15.consmr.mail.ne1.yahoo.com (sonic308-15.consmr.mail.ne1.yahoo.com [66.163.187.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D361E2B625
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 10:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1658164361; bh=xppzB0kxv5KtG37fv45GQbugTJkA94hzrsgf767sUGA=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=Lj7anAlzLC03KVoF9tysKYMSjLdn8ebskxCp6rv7uu6uNGN5ojdsPMkUNcngoPAgCt1g+2Z99Gk46clWMLCfSTbDc00jqApzYzNEo7lXFFjg2fq+XPLXXQhThFeiokuFjYhu1/wD74hfPSbTyOxAUYPmOc4lIdxuMZiqHnAtmTUF0QFxMuEXJ8KOa2JYw2bcSjvQxUzmajqYOETe2Vc6excA+2YSDDlIjs8ZlhTzCvXYZE0plYQl141MYbGxMda07S6mtYK68nXwjlpV1Ve6PfSLMobCbvYq4xK5EKmO++QrYnZqghN/MfqOyMYmEJ61AgzVtk6vpe3n4wQubx07jw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1658164361; bh=OfkCiPtmqP8Tk1RPckeS4qJX6EAdj9LC41Pg7PIeLe6=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=L00MNOtyUOMjbQ19v6sASagzA2jv+Qf1QoLde9jFOXMohbQZjg0J9QRtpOYbZ/diVCGlxO3B1S+iwHXxXUQtVbwxfI7KntwRIw9frHsS/1MXEcrTvronAbKyLEwwOEoxa9tIU2WPm+bAMDUAxNfIiKm8+0Y0hB0zut5KlqJAjxngs+6sXbJRGNgDaB8KOQAN5el9a0f2/evMh7kI1QX+PUbt8q47Z8EQBJqAFwF+Exfv1QEiVSHIKWXI/btt/fmDPpbAJ0ZK2lbOXmTDBk270ZJZQCnDi8/8nx2KI8JpfURGCuM2UTQvExPgWb/GPSxKcdnGsLV1fhMBqhYUamfSmQ==
X-YMail-OSG: mIh5kRUVM1nxarMNoEbeBYqruHczFLbuKIy2dGsbvxHswfKSHBhiae.Q9NMAcCI
 Url2YXb7M25ckR57PrAuQh_dkxF1LhrrPVM38gi4g6ASMVYs6VfjhuqlJ6JrR1Z6cYS_rmSvgAYL
 M9qX2BzLsM8g4.2Us9o10jiUnuPnVVVrovIzeYp4rGMWRIqF3PGY2fRjxhxFjU24RA0A9Npf_.Wj
 GxqcZLf3RwrVcCfr9f30RVHlD2iYNwlFb6sEjrCvMoBM2xt3zEGfbJawVANpfoivT97_0.gmFHny
 8PTGpHDBMc4YJNuclYAp6IPAthYJWZhBDD7_i.L5ssqNGGlxX8VspBhtYQ7vougufOo.IAMmKjtT
 3cOQo_.SdD7YUu5flQ1bfJkX695D7OJlacXmYqcXkjoG_d2VR1xjbuvUWpSmiMf3l4MvzJQCFxyZ
 15efGnJT9ewIjHfGAJ8odaBAsOSMheltBBUquBlB3p2s41FXBwitfwwVex0QiWZig8hoRW.ITonh
 OFGNxmxvgXTj7tl_HKk3pinX.8p454jp0xXCb.Jyuf2whJcdnSXnOfLzhXFEoU7EB1zjNP3x1zXW
 ZJB.sRDE6Fm7lIFKtu.YygJP8Py_AWUTaFzk28FdtVEwfREJtUvYMZnhQSl97HCML6toSVzl92V.
 8hJbxEia4A_SThFLKEBf8RJ_Zc4m5KNK6wWTf4xPuz__MMP7FwlYSP6I7W_SnMq8fbKzYdPT_un.
 M_MvyJ.bO6DIzmpYH_Nt2HJwSwo_t6Z_nRM52vwerjyg8xfo.xXjfqjQ2Txe2KpQuKV.ccJEqCQu
 h1oriLmH3h3JQUGnekdnAbZtsQo_dr9nQe2cboloaHp9gWft4t1k9UtcXbBNA1LOEvc5OBU1i1Os
 e3T3dDSuCFsRkM5kSVcTSbxZgkv9J93cdjOZ6y19Y0_N80I6y9ncmmqF72xUChfLxDT7naEAyoZ_
 6Ph3GldXnNUQhQuattpRrxClna.P8tSq.AM0or9GKprjlF9kLkGYh9j984SyiozjtarfZ2KjiPs0
 e1tc4bjXwXBT8MyY.A3JKLou6zbUcGiGIrSR_5phFhcLYpuRGfzaEn.pG7icsN8tv4rZGcrHM7tD
 cBLDovtOi1iHvkEByfwpQa_RGmYFHCzxXWdIwOT9yY6bIGC0c.alXlIgs92fLn6D1uZzanznFb5_
 P42NF5bkSz_vORVeZ7_mzb1tOvXe5YJWGoSjTOeKaDjihcmupTdzIdkFRLsD14.G_qi3YaBQ_Uev
 vjMT78Bx_AT9SScWRsSodOQaQsV1COapBOQsw3Aiat2.KA.kpwuwqLxGLfDc.t7c_tkymWuExr3a
 Y78R96hjONPSL.cV9d3MIvmN_RCnaih0qK17SsiDvaqfIXCTdszwfqOO3fyfehnyLJcP1fZcoMCX
 SweaW9JSrZT4k0m8Jiy9Hn6QPSiOYl8B9pnKqdpoEPZaK_u6nr9bqN9kct0ekQCn1rrZXJoOlg56
 E24qNVQ7o1V4iJuQdFnhIhHqPCA4QmLcG6yOi1vtp8QZcTdip9ruJK0.XH80QDeLAfhFpkr2wN0B
 X8A0SJC15RdqgSQ4CrayiilI6QMsRMNFp_cBQu3r03bw7T5goiTcvVCz.9PSjo768szPref2spCi
 xnWAfxEKgpNZrHwLuieymvISp5bvxTQeDIXKqNKAF3Z7nxh9UH1KIdpyMOODPOu_x_DNbfYPNr45
 gkmTwJoYl9GOhHBuEE0d1cJnouMxrqWqjSa_4BAucHJXrMjCB_xBxvAsAJOqCcydfejbLgr6F8g6
 nY2ACVhXNYdB6DTZK5k9BmuAUj56gqi8pX_aLTcTCtvC6V9zYVPZ8VWe0uzEWbLPDEwM2Ujn1b.h
 _izhZQKObUnVB5PwtX.Rp0DQ9EElHh_8UmpCDI6FuzaLnKdfy5g0_wAIfmi7H3yp6Mr5XFpWa_Gv
 IBbYGERhnsMSxtYIEhyG8aaaakHbhKfxjonTsFJYq0r4JHxWv1xK0YV601Hx0qFAFpVTJKuYYeAl
 OVPMXFXYrRYKTzEObAHSCnrMJSaDNixLJQxj97PRBw8O8dsqaOuDeeTfcvsoT_UoG.ig9zJrDJCR
 FYwzDo2ruK9NbyHs7JdU0NooIrK95qg2oomEn4svaFSvgFSyLjToDSoYzlRlv2eq9YziZ078.zIH
 0J9219aF8l9qAGuZSQwEfVat02Lz47YNM4WyBcU2yGmb0m.ZXnJwUcGN3KlHV.CRHr1QbQYhu7Zs
 JHuYPnt.t1YkXiRKa5M4jOaseIFl7wR.7CfcMb10nBvD8m824G8TKpP0fih9uaNo2xPSHdPERXtJ
 3tqFqLCO0l3edNZIa9w--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Mon, 18 Jul 2022 17:12:41 +0000
Received: by hermes--production-gq1-56bb98dbc7-fxknz (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 4dcb57f26f3bd08333e217284802ba60;
          Mon, 18 Jul 2022 17:12:37 +0000 (UTC)
Message-ID: <e139a585-ece7-7813-7c90-9ffc3a924a87@schaufler-ca.com>
Date:   Mon, 18 Jul 2022 10:12:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd file
 op
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com, casey@schaufler-ca.com
References: <20220715191622.2310436-1-mcgrof@kernel.org>
 <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
 <CAHC9VhRzm=1mh9bZKEdLSG0vet=amQDVpuZk+1shMuXYLV_qoQ@mail.gmail.com>
 <CAHC9VhQm3CBUkVz2OHBmuRi1VDNxvfWs-tFT2UO9LKMbO7YJMg@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhQm3CBUkVz2OHBmuRi1VDNxvfWs-tFT2UO9LKMbO7YJMg@mail.gmail.com>
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

On 7/15/2022 8:33 PM, Paul Moore wrote:
> On Fri, Jul 15, 2022 at 3:52 PM Paul Moore <paul@paul-moore.com> wrote:
>> On Fri, Jul 15, 2022 at 3:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 7/15/22 1:16 PM, Luis Chamberlain wrote:
>>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>>>> add infrastructure for uring-cmd"), this extended the struct
>>>> file_operations to allow a new command which each subsystem can use
>>>> to enable command passthrough. Add an LSM specific for the command
>>>> passthrough which enables LSMs to inspect the command details.
>>>>
>>>> This was discussed long ago without no clear pointer for something
>>>> conclusive, so this enables LSMs to at least reject this new file
>>>> operation.
>>> From an io_uring perspective, this looks fine to me. It may be easier if
>>> I take this through my tree due to the moving of the files, or the
>>> security side can do it but it'd have to then wait for merge window (and
>>> post io_uring branch merge) to do so. Just let me know. If done outside
>>> of my tree, feel free to add:
> I forgot to add this earlier ... let's see how the timing goes, I
> don't expect the LSM/Smack/SELinux bits to be ready and tested before
> the merge window opens so I'm guessing this will not be an issue in
> practice, but thanks for the heads-up.

I have a patch that may or may not be appropriate. I ran the
liburing tests without (additional) failures, but it looks like
there isn't anything there testing uring_cmd. Do you have a
test tucked away somewhere I can use?

Thanks.

