Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80610391D35
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 18:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhEZQka (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 12:40:30 -0400
Received: from sonic308-15.consmr.mail.ne1.yahoo.com ([66.163.187.38]:37395
        "EHLO sonic308-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234561AbhEZQka (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 12:40:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1622047136; bh=S1uCvUeRrkRlNNhizFte879dzyrvDfFrtLEUTbXlxnA=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=VSry5DfhvIQ/vR475iOdgRERNHKUVuicQO6UpRC6vpIhh3tFIpZ/P5Ul9Zq7UPqXQWnbFTw9fUwj+ZQu9kBGcV53Li7vFxPp9GCA/+hVIC+uVt25dPDXXe+EjmXS8byjjxhQs8k+a4kFX3eLeor2eWApf1jvjp6tjZZL4fmnlVV/auA0ltjewIwguv609a27YlLuyZ8voWi/g6poy5PmjVzg+zOYjAx5/IazKdLKugEZ1xUu871crOn+481X/0WUMKr5YH6/yo7GXIMs9i7DoMbLubjaAmJrO/nRHwTRl3mLc+qGGT1cwWWbARJluuBnlFL/iBQghYE6XlfMCuKZiA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1622047136; bh=YhU2c0jxaqiTWK1GpKBrgflwFeJueINRH8R5pCOngg9=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=Z1U4jlSZ4Qz9SJKIxaQ3u/pY0aHaglB3KBogoCLWcAqmyFuoxV1+BXcrkBSU8AlDU8kr/tn3jvx9X80CBkz1FMPlObut1lWCDU/FNqp56b5QxG67zCPHdjM4LLILdihxd7Rn3nENiSF3ToHThN1iGtLganwNTJNbu8Lrs0i5PK6cS/WH6mXs6UuTNZXS+6mFOgg3Mgmf9rHUSeGPfrJSJSqYzQrsac0aD2G8uAWlKBpjyORi32TIB99TsIprGZdCFxZPw5dINJc1g8qUVzh2j96tGUbLSahMkTBzNLUsIAUR7waIUHXy5NvYX5df0FLJ6Qrv1s8rPv7lCIfDmFJv5A==
X-YMail-OSG: 8lkYVV8VM1kbTqr9Th6F.3C8TFnV1n1rIwqO_GY0lDBydPIeEN.bNEkrr_vPDAE
 Oauw3Ktk5dM5Jlzu8YJJSuvmoaTE9mL9eZ18jzx3HSwnFdkDSy5_HBO2n2e6auZTE2_f1I8dYIPm
 E151K5javFD0g9ER.sX48LfoBL1EsCQAU9QQMEOnQgodQnqK55QlUoZ4fMQ2GDanhPsd0IZHo2op
 nPK0lHMI5JUFaUuMg_iK3h1VscF8h8W1yRX4YPHtnZjIhOu_QyoTQHf_jFEDaB4ceM3hl7TnQdT4
 k3k3GVAgYGftylkoZSaAldYZZkYFRNjkxNjnfaLEw1DRMcETzmXM8MwK4yes7qM9sAZKYu6.Ywqo
 5NpLgVpLohLUiwKIQ5KmKrlFwj8Clsdl5l35ItV8vnbSg0Um5iK0i8M0LGIe_XXu4WPSuxRI_LJp
 krAUuDRMNZK54oi0I9lZwCPmrXWGKOQK7MlPzEdH7XRbmdZTJ8gO9rAk13_n3WRuPXLweD.HuVOF
 9DL.EyafYso3.lt9nMGQd2EwujwviEabdmNzLeJjEeOtaa56XEPCBVragWAUY1Ps_1yp_lLNfUaU
 9MdwxK2gmSYPNTnqiTb3jcSC9kwWt7yh0YASSNXTKjZO13atq8IfxIMQYvr1qhK.aIDLyK.Tiy7I
 ehoJ4.M58jMXoVvRvpQ5tS_meEglf8M3OpCEoqmuZPO9aHMI_YUHywFcUHZonIKTIu.68k1YcqnY
 n4y19RXC2FZNsEVKyd.Gzb2dCRRu10nFIFxMHrb5u95sYBPgXReWqSkM_92RvXARAX1bEJmwR9NM
 xDPZZIDOYnHlW3iSYr.aSkyPN2Qd2QlFC11QW2x6LDaLQ5ohcD7NLCOOZaSZz4qMN4lj4d0sZXjZ
 j6.3YSELNPNohhFu9w5yBT09G8o73pGkvpB4E2iB5xNMHWqJ4TTomz_xexn1a6JldwCWPmyVoPJc
 8i30K6vUltnVRjTYoe7Jkc7g5cvIWhVgaFkOywWpeMbyXLOp3q2KDdcedfz5y3fYys.G1hSdPdA2
 lXZ7Dp3O3EnuqOgiZ7O7kx2rRovY52NufV84tEkub_iZEtKR.ui3HcwggGFztmbO5GyVNmD26jU2
 tXfsB82W_rM1PtTNAUDYLRV9jwJ14a_Tvj0dskGQhjoRHMHMCseZ066eCeuOTJ1ZJUN_fBh16.wH
 kLYOueBHZ71CgKgDoablqnvPqnPC5M5.bJ3opuh3cIo1O.N.lE6wE3hKwluTnnHzXDRlx1pWx7kZ
 xss2hU43QXCuU7EkxIbi1Jbg77D7F4kTHbPMiK0C.pJblc1S8S1HW1rnevpeMd86EwQ3acgK1AS7
 mBnt0DWKLAPnD4MmS9o8wcp.9YehQKKDgOc1lfD9IHavpWsg0Y9Id1MXlLCp0MWSsB96Pn6gqySQ
 Vdro_LTXh36muwCsXoDWROhQt8dKwoMuIfLL4fOljuk658QGVCubSfcvrrGEZwJ8s6bSdvqu0ZmF
 6aI.GYPauYgOEkkrg44XBjNxYmhj4Q9MObBW11GH4UzD0ZL9j_vq7uiXp.ZNEaT5MH3wtpXGEnRG
 v6MkIJj0X6hnX.O625STtYFxqhAn5Y_hXDd0TQ_yo.3CMhuzJP1KxRDiuM4JCtTw.gFdjyXZHket
 hA7rJpjXTU76.Kxctuao2JpHVJV.s6TdJrLn0o.gEfi.hg4o93gZwd1ayQGP65LKYzfFnU2MOS2m
 Z7.lvSy2LQ9EGf_8tfCRqFkhAbqiYDrnb9IT.A9AGBfsrwdugex7kAikfQnfdbozxYyfAklousl_
 9MCmWG.HrIlJ0ig5kvk4ycmur0wOcUShx79ADCzuRioqq_gHwdJl6n_dAxfdfHm7V3FlAays9vnQ
 p0iOqLB5xXGKnfjZtF3.ZryxVNH3ztPPyWjN4YlgvDHOK.8ukZmNUac2Kgwz576GQafwJuEQcwu4
 VpGXhYin1WzUkWf114JyigDDzj7OqfiYbXSj3um.h3e9OQiEnkwmv3E6nQQ_.Tn_3XJ2Rp5npSki
 lqXLXayQCgMGWZY95hyTgiBT8w0JW6ZqTu4Uf5q3Oy82Kf5mhXlwUhhbIk_TeJu7C5T8bTkGz4IZ
 iaf35lzD3hBG3tFYarfwnVDjAqY1e_24Z1NmSg7Jd5.am4tPnP9GhwGSxOWrn8r1VNfnxBajWv3y
 Xa9hNlB8vDXM3URelVvGkpy68bXgBvcS9gx7gcbYBjT9u8DB0pOVu7u7ya_eCmqBGbUrzTT_QJ2O
 zCwZRMbn9il0EwzCsVD.rRSVqmkcsjjs4LWjfTe80BmbcceJl_YDVZwh_nPewzDs7W9QhpHidieI
 ftUkY5r5bY87mJDHvO5RZ6LqbYYEz1hnC.Ue9YpkpIKXiophJrago2iwo874dcXzqAxqxcN4Lppn
 n1n.UiCN45R7DHpjX4m27A3j5rRvEf8OX_TpkqR7qZGd7lahBi5NcKQvZ8B1rROVBEhuPrTY6nwH
 vatjbUtYq4tyVXuzUb9r_rdaa13lp1NTKv6l9aXdlsAjpvG14kcXBis7t99Rrmm8lPRljnNEGzW0
 21IOZVyDPooBkGcM719FjZpCQ0YVpR7mYMDhyYIog9EGyfMty8Pa1nn9BdxMg84s_.4zdRmCJfKr
 tEneTgAhwgfwC3drib_2PAifQhIUJhRQxmajwTfYlPjT.dTUJFOpX_GyErtDW5_JbVkmLn5W8WHN
 CjyUBgOlBo_2QGQlC74Ftu6NCxIk1b.368oJfjjpH6DRiA3jEGKZFJ4ZvSGmZLBu_blaodFu37ta
 G7kh4ks1HoKoWG47YJA5UBPA6IF8f5J37i8efafqN5g6C7BhmwjQiPObcbu7m0Iyudm4ufCxjpx4
 idx9QhsXYzWmOCpUXFZQHprZadeHgJLT2NXu8dSlbXAAN87Rnf.5wPiET2IgOdseCKS8R39EY2or
 mPZv7xusis.25Rsc9iPqkF.Ave3BXRESVtiMZMJSYnmSkbGStHUu81fxHe3e59mxh91kpQLwzg0p
 YcPZfUjPObk8maP6zq5p.4X3GxZnLuwav1bFw42ieUgjeRXAdU34dQn2F_L7JhfePHKJ4FiTVQu5
 Y1UT0AWDied1x2wdzyp_FjZEH83ed5Cz78OLpitGsvnA5P.I2JSg8LCj1ZBe03wCrgol.52rI2AJ
 V9w0I_YfjZCA_fDDnKcmxG12TJ05GE8idZ.I3dN83PqueBBoBAGUsW5xhS1QRlzi_uCb0WgsSw2a
 VrTXmd_OkiwmCTo1jxhxeH_Tf5JO711aXCTQhwPY6i9jdfpBkptCFytHfLP9H_m6fnSYseZf73.1
 Heg--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Wed, 26 May 2021 16:38:56 +0000
Received: by kubenode564.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID eea3acaa54f624e35a23ec456cbd982a;
          Wed, 26 May 2021 16:38:50 +0000 (UTC)
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Victor Stewart <v@nametag.social>,
        Stefan Metzmacher <metze@samba.org>
Cc:     Jens Axboe <axboe@kernel.dk>, selinux@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl>
 <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
 <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com>
 <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
 <18823c99-7d65-0e6f-d508-a487f1b4b9e7@samba.org>
 <CAM1kxwjFeawYPudx+ARBMYXgMtU_ypwuSKP7x7U7AQ69LxGQgQ@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <cba563e3-60da-3edf-e5fe-e409415ce3cc@schaufler-ca.com>
Date:   Wed, 26 May 2021 09:38:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CAM1kxwjFeawYPudx+ARBMYXgMtU_ypwuSKP7x7U7AQ69LxGQgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18368 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/2021 8:49 AM, Victor Stewart wrote:
>> I'm wondering why it's not enough to have the native auditing just to =
happen.
>>
>> E.g. all (I have checked RECVMSG,SENDMSG,SEND and CONNECT) socket rela=
ted io_uring opcodes
>> already go via security_socket_{recvmsg,sendmsg,connect}()
>>
>> IORING_OP_OPENAT* goes via do_filp_open() which is in common with the =
open[at[2]]() syscalls
>> and should also trigger audit_inode() and security_file_open().
>>
>> So why is there anything special needed for io_uring (now that the nat=
ive worker threads are used)?
>>
>> Is there really any io_uring opcode that bypasses the security checks =
the corresponding native syscall
>> would do? If so, I think that should just be fixed...
> stefan's points crossed my mind as well.
>
> but assuming iouring buy-in is required, from a design perspective,
> rather than inserting these audit conditionals in the hotpath,
> wouldn't a layering model work better?
> aka enabling auditing changes the function entry point into io_uring
> and passes operations through an auditing layer, then back to the main
> entry point. then there is no
> cost to audit disabled code, and you just force audit to pay whatever
> double processing cost that entails.

There seems to be an assumption that the audit code isn't concerned
about processing cost. This is complete nonsense. While an audit system
has to be accurate and complete (hence encompassing io_uring) it also
has to be sufficiently performant for the system to be useful when it
is enabled. It would have been real handy had the audit and LSM
requirements been designed into io_uring. The performance implications
could have been addressed up front. Instead it all has to be retrofit.
io_uring, Audit and LSM need to perform well and the best way to ensure
that the combination works is cooperation between the developers. Any
response that includes the word "just" is unlikely to be helpful.


>
> V
>
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://listman.redhat.com/mailman/listinfo/linux-audit
>

