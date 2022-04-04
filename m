Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713E64F1B47
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 23:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379577AbiDDVT7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 17:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379010AbiDDQTD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 12:19:03 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764D331922
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 09:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:To:From:Date:Message-ID;
        bh=ZFxCCEmkcG7TzB+sNx6jNrK0KOuJctrVY/tctaS7dFM=; b=0Phof6ONLvZUIsXW+7BMNxXTCp
        7s0DjkGRcxIMYm6IKYTxDOpgL6hPauLOOf/3YoaXx5HO+hiP8knVAUS0k6o2gNm3O1LuQg036REg7
        63ctwXEUU19HOzYNzOLuf5saJX9QUDjEJcrhDM6BNFuU7DhBadfZGOK5rcDQJWyw9Vchy+m3KGdld
        PIreQvSJvL4NbdfKfkC/llfGCaQZf8XmL9BhzUMwJQNuQSrzYM94eVth4MVexb4KPIFcxDIq9gwXb
        +E0gWeqeTFQWuBWF3xxUHK7DapJ4KGVLjX5Y0nSZHfxUVhdWFH1eUDWiJW6UESWXDkP39b9KFIQns
        Tgz1D8jY+y73tYr5gTsmRge2Sd5XGk3s73KtGnoqFfd35evE7zHQ35R5h0uwTy8h60+sNdIiFFrrY
        AE5x3NOOVo5pUN3AiIZf85HGNqTw/p+bDH1vAqqZUshU5LHd3LnMeDwJ7k1xU6nshqX+pfAXKjaKj
        5iNKzgPNPKYJEei7GHzFXCMB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nbPO4-005GMs-LK; Mon, 04 Apr 2022 16:17:04 +0000
Message-ID: <60f34e91-e8bf-a092-6958-388dcbf4e81c@samba.org>
Date:   Mon, 4 Apr 2022 18:17:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, Eric Wong <e@80x24.org>
Cc:     io-uring@vger.kernel.org,
        Liu Changcheng <changcheng.liu@aliyun.com>
References: <20211116224456.244746-1-e@80x24.org>
 <20220121182635.1147333-1-e@80x24.org> <20220403084820.M206428@dcvr>
 <c53378f8-87eb-43a6-afbb-e506c566ad26@kernel.dk>
 <43ac1089-9823-2094-aafa-edfc31f1f6fe@samba.org>
Subject: Re: [PULL|PATCH v3 0/7] liburing debian packaging fixes
In-Reply-To: <43ac1089-9823-2094-aafa-edfc31f1f6fe@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 04.04.22 um 18:13 schrieb Stefan Metzmacher:
> 
> Am 03.04.22 um 16:54 schrieb Jens Axboe:
>> On 4/3/22 2:48 AM, Eric Wong wrote:
>>> Eric Wong <e@80x24.org> wrote:
>>>> The previous patch 8/7 in v2 is squashed into 3/7 in this series.
>>>> Apologies for the delay since v2, many bad things happened :<
>>>>
>>>> The following changes since commit bbcaabf808b53ef11ad9851c6b968140fb430500:
>>>>
>>>>    man/io_uring_enter.2: make it clear that chains terminate at submit (2022-01-19 18:09:40 -0700)
>>>>
>>>> are available in the Git repository at:
>>>>
>>>>    https://yhbt.net/liburing.git deb-v3
>>>>
>>>> for you to fetch changes up to 77b99bb1dbe237eef38eceb313501a9fd247d672:
>>>>
>>>>    make-debs: remove dependency on git (2022-01-21 16:54:42 +0000)
>>>
>>> Hi Jens, have you had a chance to look at this series?  Thanks.
>>> I mostly abandoned hacking for a few months :x
>>
>> I never build distro packages and know very little about it, so would
>> really like Stefan et al to sign off on this. I'm about to cut the next
>> version of liburing, and would indeed be great to have better packaging
>> sorted before that.
>>
>> Does it still apply to the curren tree?
> 
> I rebased it on current master.
> 
> The last patch with this seems dangerous (from reading the diff):
> 
> -git clean -dxf
> +if git clean -dxf
> +then
> +       rm -rf .git
> 
> I'd just .git
> 
> On ubuntu 22.04 I get this error:
> 
> make[1]: Verzeichnis „/tmp/release/Ubuntu/liburing/liburing-2.2“ wird verlassen
> dh_testdir
> dh_testroot
> dh_install -a
> dh_install: warning: Compatibility levels before 10 are deprecated (level 9 in use)
> dh_install: warning: Cannot find (any matches for) "lib/*/lib*.so.*" (tried in ., debian/tmp)
> 
> dh_install: warning: liburing2 missing files: lib/*/lib*.so.*
> dh_install: warning: Cannot find (any matches for) "usr/include" (tried in ., debian/tmp)
> 
> dh_install: warning: liburing-dev missing files: usr/include
> dh_install: warning: Cannot find (any matches for) "usr/lib/*/lib*.so" (tried in ., debian/tmp)
> 
> dh_install: warning: liburing-dev missing files: usr/lib/*/lib*.so
> dh_install: warning: Cannot find (any matches for) "usr/lib/*/lib*.a" (tried in ., debian/tmp)
> 
> dh_install: warning: liburing-dev missing files: usr/lib/*/lib*.a
> dh_install: error: missing files, aborting
> make: *** [debian/rules:74: binary-arch] Fehler 25
> dpkg-buildpackage: Fehler: Unterprozess debian/rules binary lieferte Exitstatus 2
> debuild: fatal error at line 1182:
> dpkg-buildpackage -us -uc -ui failed

I also found it changes the system path of the build host:

install -D -m 755 liburing.so.2.2 /lib/x86_64-linux-gnu/liburing.so.2.2
ln -sf liburing.so.2.2 /lib/x86_64-linux-gnu/liburing.so.2
ln -sf /lib/x86_64-linux-gnu/liburing.so.2.2 /usr/lib/x86_64-linux-gnu/liburing.so

This should use some $DESTDIR magic...

Maybe the DESTDIR handling is broken in general and the reason
why I got the above errors...

metze

