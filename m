Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365C158F302
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 21:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiHJT01 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Aug 2022 15:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiHJT0V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Aug 2022 15:26:21 -0400
Received: from sonic302-28.consmr.mail.ne1.yahoo.com (sonic302-28.consmr.mail.ne1.yahoo.com [66.163.186.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECADB70E53
        for <io-uring@vger.kernel.org>; Wed, 10 Aug 2022 12:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1660159579; bh=mJ8vytFo6pdRnNgG4R8UAxA5yJdxgjKo5cAJudPVG60=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=C9OYVLW1mxRq4It7kA13YBfjDnNh2+nSOEQ2nYK9DDHuTmL11Afla+2zuR2Cpc/c+py7Qb4tmfcK1pB5IZvoYRIlZ6yPWd9HTJGXwWu5HHrbr8h02Dlhgv4CDxGjlO0hNSKwxb7pJ/0s8zZr1O+NDXqWFBCwfztsKUtEvFb0KP3qqpdCirEQ4F2/BxupQhg/SYFZ55noZl9V4KmTwxTNPGEuWloOqzRjVzJ5mRJPFLnwaed2XM4VuiUvmaa5e/x9XnFFGQNQ4ElRdnXGUEETdi1OsvlRzHht2LvwyE4NWXqPDkyNHk2suqWSlBwWJ34E06/3xLymmN26hnqC2RC6aA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1660159579; bh=50/VsK+WfIEOHK/r41jJbYyMDctNSQwSoWBOUp6H4Bp=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=pKvPck2v/W896P0gN5+entB5YIsNh8do1qQCLoHhSIAnL04TpQdXxcnZN213Dx9tlYaaZwGCRTpQrPRw1qb9MYQ1F6Yv3FGs5snoniD80RI/sxL133CgPCWs6ER0A2FtTxWo1QL+bBjgDgrZI4y2kn973QAgLS7/nj7UZdHGaWb5Db2so3itZrgza8EIqPsKHfMrL7MZ/Z/yVM3TpqwU4NPi4saizyS53JzoW7Y/px9B2IuCJ0ZYurqq7nVE+jdUb8B9o5b8mxmC3ggjFKLzyo33ONA47JtSqb9mfI2n1mR0lsyK8DSp8/rNcOsXQXrzNEgGYtmYT3l4wChq56oeKA==
X-YMail-OSG: Z3WMMsAVM1lQTBec2yGpoBwCWN2MDqXDZBKEhmj4.CZmBstM2pUrSI32DJwcQ1w
 Yl55EEaYjKVnOgVtXguiPtlabGHHtMLXvsIrpZhbgpm6f5kOQe87b4Ztyq0eTdOQb7.BuSrXWU8w
 P8.50D1D6VjbRyNceguZyUQUFXvL2Sq.Kdq_8X_U670xriL7riNx1WQhV92tzqgnYUzGq6Bl6eIW
 _MRskbyN.YLH8BkAGu.OGFHx8Di2pRhqTtyb02lzzLGW84f95aMbLpRJcvB._OUT1QBRkeqy5sZu
 lLc9Z85dEGZ4wxduXx6UOHAKCX1hXdy8F87G8LK2WyoIK_bH9XkE3zaht8.hMf8gsLu3lFSpxJpC
 YEX4AknwSnR..Abdj8O6zMk7Dewv1TbAoFptBIcVCa43QcmYFJPyjWPysD12uIKicK3qqqVAvE5f
 vHWFmddAHPgmF0tYB6Z.U6FmC0GNhqENEdzEUl6Qvs.XluxV.gWnSB0koLDrN7gbW3YCs6X.F3Qo
 drIMy0Dzi_CjNJdbjJB0vfROXH.fIvez60vO7BxPU5NVxJXUuhvPiadN4lICY2lF8xtTgrKVdjbf
 3UFEkg975NrWZEB0cJwdSwwXlGejVxu8MhDXANpy334zczRrJflunor59ZcdsO3aej6DkdDHz61Z
 FDxByH9aq2OFC3TAu2PDVM0DCVrkQNPf._iMaKJAc4WGMUuQVg7PRc30ar8GxodOXS0mCuWKKCA0
 1Ga.Id.x9UlkZJ1hndhbpUrmp.O39pkNosp0bQoApnEYfXNEX0wD_w59Q.wuu3HvZBnNUvwlhZhd
 tv0nFUC6r5EcLRZCJRBBMpu4TY5qqPQrSCSZjJLCCcRSWIw6OjYPNre4FAfl1fWz.wTHOH0aKcDr
 IcNQJ8VyXPWUCp9Il4td9T8p8hwzWQ7BNrhjgo2wvxp3iPN9og81zZa4rh5PdpwiJ1YQr1aSnbgh
 FcCcWhPMWulE3R9WL3xThDauCEt8QWp8.WWCWAVmInzU_oU1DNeOQe_APxg87Bo6s8gVtb.GLfyE
 pt0bkHIlDSLkM1p2J2b7tEYNvgUYrJGF2cioXZmL4YClWl8HClr9BVmxRwmreRtZN8kLbALKs0WK
 9V2NHwmAulqaHai2RXEDTA2hFLW8aLAbh9fao0JsNQm3ydaGaUT69wL5U1qzLiWX6rHs7ICz2q0U
 YyuxAt4s7e9fWBY.1V3HcMhuV7d2vZ4ORvOf0uYjtYSRJgSpcq5FnVRf9kMQ96WL3JcrS7EUcFzD
 SZy0lov03B4gRzKKtAX.JamaXEkKWTXgTR_lmthMjAy0UuG8H2JWPwsTmzW.XhsexNm0MoIJ.nu4
 f7Zsb1Uc8gtXgksrUSPqh5XZdxTmNMlZ0UNY14WeC6t.Ga.77S9N5Kt48ByyQTVUuuKIuEBsx5.A
 TfczddEQ4MSn6BRuz_pn2N_yMN_xp2l9nvtBHKRRKBVioj5uwp_jxmgDOVKo6g23icpKBuPwdXhZ
 f_Csn8.eM8Ime6jDoLsr36QQg9wDQI6F3D_MlZYt8D_cko_.0c9EIel2MrKF_YSqGi1fErQJETTp
 kRnvy0xjcbpTryfPy.GDMB8KcFdAm5czNrG1eBEIwR7sHH1K4KvO_OcmdIMQOLuys5_eA0xgk4do
 rkq48f01F8KKekPz2ugBflseMa2tDl6Mvc9VaTRiYBOc0veuiU.VmPJQbZzNXqXTLtlayLmgD9jA
 990sqznYlxs0Mpygyx8oEMVO1Wg_WtxJyQEJZb5ho6MO0PKUcAt2S_OluAf.0ocdPnL66mJMq4Hn
 8i5BC1pzhxqVdEs4zorgHgyJBDGCBuz9YPRIg0tJIg7GRAwCtTmRrhC00H0iAkgx_J7ViObF7E22
 NcS4FgInc1rHf1PDEeJTvuT3Juy7qHnIfouNOgox4Ngo2e3MSSaf.QwZvOdujTrxRaiOeH6M7otj
 WclpThHwRKTsvK9VCw97T023VNsqeUzAtvUS9wwr9NWNuCKF4lUpfLvEezEeotANeh3C8becN7XA
 .jI1ZxM62jN6.gcIgwqJg7zCbDtT2b9T6V4Zne5A9JpZ0CIWfL_aBYZB3tPNvaEavPk0CHaNEfJl
 kHsFxCBZLeeVg2QPVXIpASfV0k7FQ642J89yx9zCf_3txSrtArhjBe6ZMYE3sRwDN3Mf0bNERV7i
 SdVHnuTorBZVFoW5BytRE4caVUN4HXmgnjdtggooo3hqw6b.P3N2jm2gUNkQJQsJoRbGDnacxd49
 2Ath68lNsYCwKgZjS7rF_aGnUgh6TXJyYW0iLQMcxdohllEltlBqIWNwmNhOVqu5NL8xXheZ.MDW
 o8Ykxc2uzcZwbPzh7M9VUO4sfrPYlrQ--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Wed, 10 Aug 2022 19:26:19 +0000
Received: by hermes--production-bf1-7586675c46-6jlzf (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID b391e8eafb5eeecc97092624165da8e1;
          Wed, 10 Aug 2022 19:26:14 +0000 (UTC)
Message-ID: <d634ce85-f69b-5441-a72b-ca161cc1f00d@schaufler-ca.com>
Date:   Wed, 10 Aug 2022 12:26:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd file
 op
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        joshi.k@samsung.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com,
        casey@schaufler-ca.com
References: <20220715191622.2310436-1-mcgrof@kernel.org>
 <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
 <YvP1jK/J4m8TE8BZ@bombadil.infradead.org>
 <CAHC9VhQnQqP1ww7fvCzKp_o1n7iMyYb564HSZy1Ed7k1-nD=jQ@mail.gmail.com>
 <YvP+aiGcBsik+v3y@bombadil.infradead.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <YvP+aiGcBsik+v3y@bombadil.infradead.org>
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

On 8/10/2022 11:52 AM, Luis Chamberlain wrote:
> On Wed, Aug 10, 2022 at 02:39:54PM -0400, Paul Moore wrote:
>> On Wed, Aug 10, 2022 at 2:14 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>>> On Fri, Jul 15, 2022 at 01:28:35PM -0600, Jens Axboe wrote:
>>>> On 7/15/22 1:16 PM, Luis Chamberlain wrote:
>>>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>>>>> add infrastructure for uring-cmd"), this extended the struct
>>>>> file_operations to allow a new command which each subsystem can use
>>>>> to enable command passthrough. Add an LSM specific for the command
>>>>> passthrough which enables LSMs to inspect the command details.
>>>>>
>>>>> This was discussed long ago without no clear pointer for something
>>>>> conclusive, so this enables LSMs to at least reject this new file
>>>>> operation.
>>>> From an io_uring perspective, this looks fine to me. It may be easier if
>>>> I take this through my tree due to the moving of the files, or the
>>>> security side can do it but it'd have to then wait for merge window (and
>>>> post io_uring branch merge) to do so. Just let me know. If done outside
>>>> of my tree, feel free to add:
>>>>
>>>> Acked-by: Jens Axboe <axboe@kernel.dk>
>>> Paul, Casey, Jens,
>>>
>>> should this be picked up now that we're one week into the merge window?
>> Your timing is spot on!  I wrapped up a SELinux/SCTP issue by posting
>> the patches yesterday and started on the io_uring/CMD patches this
>> morning :)
>>
>> Give me a few days to get this finished, tested, etc. and I'll post a
>> patchset with your main patch, the Smack patch from Casey, the SELinux
>> patch, and the /dev/null patch so we can all give it a quick sanity
>> check before I merge it into the LSM/stable branch and send it to
>> Linus.  Does that sound okay?

It's taking a while to get a satisfactory test going for Smack,
but I should have something in a few days.

> Works with me! But just note I'll be away on vacation starting tomorrow
> in the woods looking for Bigfoot with my dog,

Bigfoot was sighted lounging on Chuckanut Rock a couple weeks ago.

>  so I won't be around. And
> I suspect Linus plans to release 6.0 on Sunday, if the phb-crystall-ball [0]
> is still as accurate.
>
> [0] http://deb.tandrin.de/phb-crystal-ball.htm
>
>   Luis
