Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDA35283EB
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 14:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiEPMMf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 08:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiEPMMd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 08:12:33 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5461E275E1;
        Mon, 16 May 2022 05:12:31 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g12so2690755edq.4;
        Mon, 16 May 2022 05:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lZ51yxMYxu44zQdsQgL3aNGSkYEv4iHOa5VJSaJbnyY=;
        b=Xl5zcX3hoLaaO7OylGHlTIGqIr3u/4APXQ4pUbe9zDRh+4EzH2hGGrxc5+yfj+imIb
         cuRiETFserSBfzhPURt7UzMjUKIypgT78UD93j+Lhe04Aobzh5gudk/8jCWQO45nLJKX
         a2UAOX1OOSksQjYIXVizjjPthIe3UhwcKD5St97JuYoY+Xaz1PgvTLZhLuxFrzMawq05
         Zxp0cpHX8CEfX8TZDJ+Xy/xDDfKHvpL76f6lMxapuv438hEpHfQD6RV/SU0/2RHVvFT4
         90RLzgapGrCbeMQaDaqKSBtk4iQJtjtkwELxGpHXSk66/Zuli5giiGctohDHn+Tv5CSh
         4W/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lZ51yxMYxu44zQdsQgL3aNGSkYEv4iHOa5VJSaJbnyY=;
        b=xLc3L4lu21UEsbTQAI8YXrgGn69aQ21dXb6cVP4Bg3q8F6KmFKEYvZJJSAu9N58tbq
         3ZmQ1ahnOmXruK6BBiLXRzeuEUkyTCPSzkFBtWfC6fyam/f0qMRdoZjKsOIaw/3vNQfv
         DaAqtg2Az5Ca9Am8CWBwLaqK/JYc4lfBkUGsCWowj/kzBwAD3azpORkv1fDH4Jot/IxQ
         8DosP61oPBIQZZiyycIsS1XdWkrVXO/BX3MXo/lXox9Qk8yn3Oeiqh0luUqtOrYEhaQv
         OVwDput5A9zpPfbkYan955Im1cnyfK64wx/5xZrtH6l/Rz79djQ0gAfgOmhaPLNzVOge
         iKZQ==
X-Gm-Message-State: AOAM531GZPRa7yDMc/dbLWZWgHEUVZMhR1s17C6tq2Z1QsVf+x5YgOTt
        sAn+8yoD7GJ11rHFTJ4QIhtm4ghZcEA=
X-Google-Smtp-Source: ABdhPJwnLsOCCxbN9zwfh3mZx7j+THeFmenqFonfgj0zH5CqYxqz1w2Vq3wSqe1v4fhAC9Ln0/kM2g==
X-Received: by 2002:aa7:d415:0:b0:42a:bb4d:7deb with SMTP id z21-20020aa7d415000000b0042abb4d7debmr1624523edq.6.1652703149728;
        Mon, 16 May 2022 05:12:29 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.232.94])
        by smtp.gmail.com with ESMTPSA id y24-20020aa7ccd8000000b0042617ba6397sm5197269edt.33.2022.05.16.05.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 05:12:29 -0700 (PDT)
Message-ID: <41c86189-0d1f-60f0-ca8e-f80b3ccf5130@gmail.com>
Date:   Mon, 16 May 2022 13:12:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Daniel Harding <dharding@living180.net>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Jens Axboe <axboe@kernel.dk>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
 <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
 <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
 <2436d42c-85ca-d060-6508-350c769804f1@gmail.com>
 <ad9c31e5-ee75-4df2-c16d-b1461be1901a@living180.net>
 <fb0dbd71-9733-0208-48f2-c5d22ed17510@gmail.com>
 <a204ba93-7261-5c6e-1baf-e5427e26b124@living180.net>
 <bd932b5a-9508-e58f-05f8-001503e4bd2b@gmail.com>
 <12a57dd9-4423-a13d-559b-2b1dd2fb0ef3@living180.net>
 <897dc597-fc0a-34ec-84b8-7e1c4901e0fc@leemhuis.info>
 <c2f956e2-b235-9937-d554-424ae44c68e4@living180.net>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c2f956e2-b235-9937-d554-424ae44c68e4@living180.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNS8xNS8yMiAxOTozNCwgRGFuaWVsIEhhcmRpbmcgd3JvdGU6DQo+IE9uIDUvMTUvMjIg
MTE6MjAsIFRob3JzdGVuIExlZW1odWlzIHdyb3RlOg0KPj4gT24gMDQuMDUuMjIgMDg6NTQs
IERhbmllbCBIYXJkaW5nIHdyb3RlOg0KPj4+IE9uIDUvMy8yMiAxNzoxNCwgUGF2ZWwgQmVn
dW5rb3Ygd3JvdGU6DQo+Pj4+IE9uIDUvMy8yMiAwODozNywgRGFuaWVsIEhhcmRpbmcgd3Jv
dGU6DQo+Pj4+PiBbUmVzZW5kIHdpdGggYSBzbWFsbGVyIHRyYWNlXQ0KPj4+Pj4gT24gNS8z
LzIyIDAyOjE0LCBQYXZlbCBCZWd1bmtvdiB3cm90ZToNCj4+Pj4+PiBPbiA1LzIvMjIgMTk6
NDksIERhbmllbCBIYXJkaW5nIHdyb3RlOg0KPj4+Pj4+PiBPbiA1LzIvMjIgMjA6NDAsIFBh
dmVsIEJlZ3Vua292IHdyb3RlOg0KPj4+Pj4+Pj4gT24gNS8yLzIyIDE4OjAwLCBKZW5zIEF4
Ym9lIHdyb3RlOg0KPj4+Pj4+Pj4+IE9uIDUvMi8yMiA3OjU5IEFNLCBKZW5zIEF4Ym9lIHdy
b3RlOg0KPj4+Pj4+Pj4+PiBPbiA1LzIvMjIgNzozNiBBTSwgRGFuaWVsIEhhcmRpbmcgd3Jv
dGU6DQo+Pj4+Pj4+Pj4+PiBPbiA1LzIvMjIgMTY6MjYsIEplbnMgQXhib2Ugd3JvdGU6DQo+
Pj4+Pj4+Pj4+Pj4gT24gNS8yLzIyIDc6MTcgQU0sIERhbmllbCBIYXJkaW5nIHdyb3RlOg0K
Pj4+Pj4+Pj4+Pj4+PiBJIHVzZSBseGMtNC4wLjEyIG9uIEdlbnRvbywgYnVpbHQgd2l0aCBp
by11cmluZyBzdXBwb3J0DQo+Pj4+Pj4+Pj4+Pj4+ICgtLWVuYWJsZS1saWJ1cmluZyksIHRh
cmdldGluZyBsaWJ1cmluZy0yLjEuwqAgTXkga2VybmVsDQo+Pj4+Pj4+Pj4+Pj4+IGNvbmZp
ZyBpcyBhDQo+Pj4+Pj4+Pj4+Pj4+IHZlcnkgbGlnaHRseSBtb2RpZmllZCB2ZXJzaW9uIG9m
IEZlZG9yYSdzIGdlbmVyaWMga2VybmVsDQo+Pj4+Pj4+Pj4+Pj4+IGNvbmZpZy4gQWZ0ZXIN
Cj4+Pj4+Pj4+Pj4+Pj4gbW92aW5nIGZyb20gdGhlIDUuMTYueCBzZXJpZXMgdG8gdGhlIDUu
MTcueCBrZXJuZWwgc2VyaWVzLCBJDQo+Pj4+Pj4+Pj4+Pj4+IHN0YXJ0ZWQNCj4+Pj4+Pj4+
Pj4+Pj4gbm90aWNlZCBmcmVxdWVudCBoYW5ncyBpbiBseGMtc3RvcC7CoCBJdCBkb2Vzbid0
IGhhcHBlbiAxMDAlDQo+Pj4+Pj4+Pj4+Pj4+IG9mIHRoZQ0KPj4+Pj4+Pj4+Pj4+PiB0aW1l
LCBidXQgZGVmaW5pdGVseSBtb3JlIHRoYW4gNTAlIG9mIHRoZSB0aW1lLiBCaXNlY3RpbmcN
Cj4+Pj4+Pj4+Pj4+Pj4gbmFycm93ZWQNCj4+Pj4+Pj4+Pj4+Pj4gZG93biB0aGUgaXNzdWUg
dG8gY29tbWl0DQo+Pj4+Pj4+Pj4+Pj4+IGFhNDM0NzdiMDQwMjUxZjQ1MWRiMGQ4NDQwNzNh
YzAwYThhYjY2ZWU6DQo+Pj4+Pj4+Pj4+Pj4+IGlvX3VyaW5nOiBwb2xsIHJld29yay4gVGVz
dGluZyBpbmRpY2F0ZXMgdGhlIHByb2JsZW0gaXMgc3RpbGwNCj4+Pj4+Pj4+Pj4+Pj4gcHJl
c2VudA0KPj4+Pj4+Pj4+Pj4+PiBpbiA1LjE4LXJjNS4gVW5mb3J0dW5hdGVseSBJIGRvIG5v
dCBoYXZlIHRoZSBleHBlcnRpc2Ugd2l0aCB0aGUNCj4+Pj4+Pj4+Pj4+Pj4gY29kZWJhc2Vz
IG9mIGVpdGhlciBseGMgb3IgaW8tdXJpbmcgdG8gdHJ5IHRvIGRlYnVnIHRoZSBwcm9ibGVt
DQo+Pj4+Pj4+Pj4+Pj4+IGZ1cnRoZXIgb24gbXkgb3duLCBidXQgSSBjYW4gZWFzaWx5IGFw
cGx5IHBhdGNoZXMgdG8gYW55IG9mIHRoZQ0KPj4+Pj4+Pj4+Pj4+PiBpbnZvbHZlZCBjb21w
b25lbnRzIChseGMsIGxpYnVyaW5nLCBrZXJuZWwpIGFuZCByZWJ1aWxkIGZvcg0KPj4+Pj4+
Pj4+Pj4+PiB0ZXN0aW5nIG9yDQo+Pj4+Pj4+Pj4+Pj4+IHZhbGlkYXRpb24uwqAgSSBhbSBh
bHNvIGhhcHB5IHRvIHByb3ZpZGUgYW55IGZ1cnRoZXINCj4+Pj4+Pj4+Pj4+Pj4gaW5mb3Jt
YXRpb24gdGhhdA0KPj4+Pj4+Pj4+Pj4+PiB3b3VsZCBiZSBoZWxwZnVsIHdpdGggcmVwcm9k
dWNpbmcgb3IgZGVidWdnaW5nIHRoZSBwcm9ibGVtLg0KPj4+Pj4+Pj4+Pj4+IERvIHlvdSBo
YXZlIGEgcmVjaXBlIHRvIHJlcHJvZHVjZSB0aGUgaGFuZz8gVGhhdCB3b3VsZCBtYWtlIGl0
DQo+Pj4+Pj4+Pj4+Pj4gc2lnbmlmaWNhbnRseSBlYXNpZXIgdG8gZmlndXJlIG91dC4NCj4+
Pj4+Pj4+Pj4+IEkgY2FuIHJlcHJvZHVjZSBpdCB3aXRoIGp1c3QgdGhlIGZvbGxvd2luZzoN
Cj4+Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4+PiDCoMKgwqDCoMKgIHN1ZG8gbHhjLWNyZWF0ZSAt
LW4gbHhjLXRlc3QgLS10ZW1wbGF0ZSBkb3dubG9hZCAtLWJkZXYNCj4+Pj4+Pj4+Pj4+IGRp
ciAtLWRpciAvdmFyL2xpYi9seGMvbHhjLXRlc3Qvcm9vdGZzIC0tIC1kIHVidW50dSAtciBi
aW9uaWMNCj4+Pj4+Pj4+Pj4+IC1hIGFtZDY0DQo+Pj4+Pj4+Pj4+PiDCoMKgwqDCoMKgIHN1
ZG8gbHhjLXN0YXJ0IC1uIGx4Yy10ZXN0DQo+Pj4+Pj4+Pj4+PiDCoMKgwqDCoMKgIHN1ZG8g
bHhjLXN0b3AgLW4gbHhjLXRlc3QNCj4+Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4+PiBUaGUgbHhj
LXN0b3AgY29tbWFuZCBuZXZlciBleGl0cyBhbmQgdGhlIGNvbnRhaW5lciBjb250aW51ZXMN
Cj4+Pj4+Pj4+Pj4+IHJ1bm5pbmcuDQo+Pj4+Pj4+Pj4+PiBJZiB0aGF0IGlzbid0IHN1ZmZp
Y2llbnQgdG8gcmVwcm9kdWNlLCBwbGVhc2UgbGV0IG1lIGtub3cuDQo+Pj4+Pj4+Pj4+IFRo
YW5rcywgdGhhdCdzIHVzZWZ1bCEgSSdtIGF0IGEgY29uZmVyZW5jZSB0aGlzIHdlZWsgYW5k
IGhlbmNlIGhhdmUNCj4+Pj4+Pj4+Pj4gbGltaXRlZCBhbW91bnQgb2YgdGltZSB0byBkZWJ1
ZywgaG9wZWZ1bGx5IFBhdmVsIGhhcyB0aW1lIHRvDQo+Pj4+Pj4+Pj4+IHRha2UgYSBsb29r
DQo+Pj4+Pj4+Pj4+IGF0IHRoaXMuDQo+Pj4+Pj4+Pj4gRGlkbid0IG1hbmFnZSB0byByZXBy
b2R1Y2UuIENhbiB5b3UgdHJ5LCBvbiBib3RoIHRoZSBnb29kIGFuZCBiYWQNCj4+Pj4+Pj4+
PiBrZXJuZWwsIHRvIGRvOg0KPj4+Pj4+Pj4gU2FtZSBoZXJlLCBpdCBkb2Vzbid0IHJlcHJv
ZHVjZSBmb3IgbWUNCj4+Pj4+Pj4gT0ssIHNvcnJ5IGl0IHdhc24ndCBzb21ldGhpbmcgc2lt
cGxlLg0KPj4+Pj4+Pj4gIyBlY2hvIDEgPiAvc3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5nL2V2
ZW50cy9pb191cmluZy9lbmFibGUNCj4+Pj4+Pj4+PiBydW4gbHhjLXN0b3ANCj4+Pj4+Pj4+
Pg0KPj4+Pj4+Pj4+ICMgY3AgL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy90cmFjZSB+L2lv
dS10cmFjZQ0KPj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4gc28gd2UgY2FuIHNlZSB3aGF0J3MgZ29p
bmcgb24/IExvb2tpbmcgYXQgdGhlIHNvdXJjZSwgbHhjIGlzIGp1c3QNCj4+Pj4+Pj4+PiB1
c2luZw0KPj4+Pj4+Pj4+IHBsYWluIFBPTExfQURELCBzbyBJJ20gZ3Vlc3NpbmcgaXQncyBu
b3QgZ2V0dGluZyBhIG5vdGlmaWNhdGlvbg0KPj4+Pj4+Pj4+IHdoZW4gaXQNCj4+Pj4+Pj4+
PiBleHBlY3RzIHRvLCBvciBpdCdzIFBPTExfUkVNT1ZFIG5vdCBkb2luZyBpdHMgam9iLiBJ
ZiB3ZSBoYXZlIGENCj4+Pj4+Pj4+PiB0cmFjZQ0KPj4+Pj4+Pj4+IGZyb20gYm90aCBhIHdv
cmtpbmcgYW5kIGJyb2tlbiBrZXJuZWwsIHRoYXQgbWlnaHQgc2hlZCBzb21lIGxpZ2h0DQo+
Pj4+Pj4+Pj4gb24gaXQuDQo+Pj4+Pj4+IEl0J3MgbGF0ZSBpbiBteSB0aW1lem9uZSwgYnV0
IEknbGwgdHJ5IHRvIHdvcmsgb24gZ2V0dGluZyB0aG9zZQ0KPj4+Pj4+PiB0cmFjZXMgdG9t
b3Jyb3cuDQo+Pj4+Pj4gSSB0aGluayBJIGdvdCBpdCwgSSd2ZSBhdHRhY2hlZCBhIHRyYWNl
Lg0KPj4+Pj4+DQo+Pj4+Pj4gV2hhdCdzIGludGVyZXN0aW5nIGlzIHRoYXQgaXQgaXNzdWVz
IGEgbXVsdGkgc2hvdCBwb2xsIGJ1dCBJIGRvbid0DQo+Pj4+Pj4gc2VlIGFueSBraW5kIG9m
IGNhbmNlbGxhdGlvbiwgbmVpdGhlciBjYW5jZWwgcmVxdWVzdHMgbm9yIHRhc2svcmluZw0K
Pj4+Pj4+IGV4aXQuIFBlcmhhcHMgaGF2ZSB0byBnbyBsb29rIGF0IGx4YyB0byBzZWUgaG93
IGl0J3Mgc3VwcG9zZWQNCj4+Pj4+PiB0byB3b3JrDQo+Pj4+PiBZZXMsIHRoYXQgbG9va3Mg
ZXhhY3RseSBsaWtlIG15IGJhZCB0cmFjZS7CoCBJJ3ZlIGF0dGFjaGVkIGdvb2QgdHJhY2UN
Cj4+Pj4+IChjYXB0dXJlZCB3aXRoIGxpbnV4LTUuMTYuMTkpIGFuZCBhIGJhZCB0cmFjZSAo
Y2FwdHVyZWQgd2l0aA0KPj4+Pj4gbGludXgtNS4xNy41KS7CoCBUaGVzZSBhcmUgdGhlIGRp
ZmZlcmVuY2VzIEkgbm90aWNlZCB3aXRoIGp1c3QgYQ0KPj4+Pj4gdmlzdWFsIHNjYW46DQo+
Pj4+Pg0KPj4+Pj4gKiBCb3RoIHRyYWNlcyBoYXZlIHRocmVlIGlvX3VyaW5nX3N1Ym1pdF9z
cWUgY2FsbHMgYXQgdGhlIHZlcnkNCj4+Pj4+IGJlZ2lubmluZywgYnV0IGluIHRoZSBnb29k
IHRyYWNlLCB0aGVyZSBhcmUgZnVydGhlcg0KPj4+Pj4gaW9fdXJpbmdfc3VibWl0X3NxZSBj
YWxscyB0aHJvdWdob3V0IHRoZSB0cmFjZSwgd2hpbGUgaW4gdGhlIGJhZA0KPj4+Pj4gdHJh
Y2UsIHRoZXJlIGFyZSBub25lLg0KPj4+Pj4gKiBUaGUgZ29vZCB0cmFjZSB1c2VzIGEgbWFz
ayBvZiBjMyBmb3IgaW9fdXJpbmdfdGFza19hZGQgbXVjaCBtb3JlDQo+Pj4+PiBvZnRlbiB0
aGFuIHRoZSBiYWQgdHJhY2U6wqAgdGhlIGJhZCB0cmFjZSB1c2VzIGEgbWFzayBvZiBjMyBv
bmx5IGZvcg0KPj4+Pj4gdGhlIHZlcnkgbGFzdCBjYWxsIHRvIGlvX3VyaW5nX3Rhc2tfYWRk
LCBidXQgYSBtYXNrIG9mIDQxIGZvciB0aGUNCj4+Pj4+IG90aGVyIGNhbGxzLg0KPj4+Pj4g
KiBJbiB0aGUgZ29vZCB0cmFjZSwgbWFueSBvZiB0aGUgaW9fdXJpbmdfY29tcGxldGUgY2Fs
bHMgaGF2ZSBhDQo+Pj4+PiByZXN1bHQgb2YgMTk1LCB3aGlsZSBpbiB0aGUgYmFkIHRyYWNl
LCB0aGV5IGFsbCBoYXZlIGEgcmVzdWx0IG9mIDEuDQo+Pj4+Pg0KPj4+Pj4gSSBkb24ndCBr
bm93IHdoZXRoZXIgYW55IG9mIHRob3NlIHRoaW5ncyBhcmUgc2lnbmlmaWNhbnQgb3Igbm90
LCBidXQNCj4+Pj4+IHRoYXQncyB3aGF0IGp1bXBlZCBvdXQgYXQgbWUuDQo+Pj4+Pg0KPj4+
Pj4gSSBoYXZlIGFsc28gYXR0YWNoZWQgYSBjb3B5IG9mIHRoZSBzY3JpcHQgSSB1c2VkIHRv
IGdlbmVyYXRlIHRoZQ0KPj4+Pj4gdHJhY2VzLsKgIElmIHRoZXJlIGlzIGFueXRoaW5nIGZ1
cnRoZXIgSSBjYW4gdG8gZG8gaGVscCBkZWJ1ZywgcGxlYXNlDQo+Pj4+PiBsZXQgbWUga25v
dy4NCj4+Pj4gR29vZCBvYnNlcnZhdGlvbnMhIHRoYW5rcyBmb3IgdHJhY2VzLg0KPj4+Pg0K
Pj4+PiBJdCBzb3VuZHMgbGlrZSBtdWx0aS1zaG90IHBvbGwgcmVxdWVzdHMgd2VyZSBnZXR0
aW5nIGRvd25ncmFkZWQNCj4+Pj4gdG8gb25lLXNob3QsIHdoaWNoIGlzIGEgdmFsaWQgYmVo
YXZpb3VyIGFuZCB3YXMgc28gYmVjYXVzZSB3ZQ0KPj4+PiBkaWRuJ3QgZnVsbHkgc3VwcG9y
dCBzb21lIGNhc2VzLiBJZiB0aGF0J3MgdGhlIHJlYXNvbiwgdGhhbg0KPj4+PiB0aGUgdXNl
cnNwYWNlL2x4YyBpcyBtaXN1c2luZyB0aGUgQUJJLiBBdCBsZWFzdCwgdGhhdCdzIHRoZQ0K
Pj4+PiB3b3JraW5nIGh5cG90aGVzaXMgZm9yIG5vdywgbmVlZCB0byBjaGVjayBseGMuDQo+
Pj4gU28sIEkgbG9va2VkIGF0IHRoZSBseGMgc291cmNlIGNvZGUsIGFuZCBpdCBhcHBlYXJz
IHRvIGF0IGxlYXN0IHRyeSB0bw0KPj4+IGhhbmRsZSB0aGUgY2FzZSBvZiBtdWx0aS1zaG90
IGJlaW5nIGRvd25ncmFkZWQgdG8gb25lLXNob3QuwqAgSSBkb24ndA0KPj4+IGtub3cgZW5v
dWdoIHRvIGtub3cgaWYgdGhlIGNvZGUgaXMgYWN0dWFsbHkgY29ycmVjdCBob3dldmVyOg0K
Pj4+DQo+Pj4gaHR0cHM6Ly9naXRodWIuY29tL2x4Yy9seGMvYmxvYi83ZTM3Y2M5NmJiOTQx
NzVhOGUzNTEwMjVkMjZjYzM1ZGMyZDEwNTQzL3NyYy9seGMvbWFpbmxvb3AuYyNMMTY1LUwx
ODkNCj4+PiBodHRwczovL2dpdGh1Yi5jb20vbHhjL2x4Yy9ibG9iLzdlMzdjYzk2YmI5NDE3
NWE4ZTM1MTAyNWQyNmNjMzVkYzJkMTA1NDMvc3JjL2x4Yy9tYWlubG9vcC5jI0wyNTQNCj4+
PiBodHRwczovL2dpdGh1Yi5jb20vbHhjL2x4Yy9ibG9iLzdlMzdjYzk2YmI5NDE3NWE4ZTM1
MTAyNWQyNmNjMzVkYzJkMTA1NDMvc3JjL2x4Yy9tYWlubG9vcC5jI0wyODgtTDI5MA0KPj4g
SGksIHRoaXMgaXMgeW91ciBMaW51eCBrZXJuZWwgcmVncmVzc2lvbiB0cmFja2VyLiBOb3Ro
aW5nIGhhcHBlbmVkIGhlcmUNCj4+IGZvciByb3VuZCBhYm91dCB0ZW4gZGF5cyBub3cgYWZh
aWNzOyBvciBkaWQgdGhlIGRpc2N1c3Npb24gY29udGludWUNCj4+IHNvbWV3aGVyZSBlbHNl
Lg0KPj4NCj4+IMKgRnJvbSB3aGF0IEkgZ2F0aGVyZWQgZnJvbSB0aGlzIGRpc2N1c3Npb24g
aXMgc2VlbXMgdGhlIHJvb3QgY2F1c2UgbWlnaHQNCj4+IGJlIGluIExYQywgYnV0IGl0IHdh
cyBleHBvc2VkIGJ5IGtlcm5lbCBjaGFuZ2UuIFRoYXQgbWFrZXMgaXQgc2lsbCBhDQo+PiBr
ZXJuZWwgcmVncmVzc2lvbiB0aGF0IHNob3VsZCBiZSBmaXhlZDsgb3IgaXMgdGhlcmUgYSBz
dHJvbmcgcmVhc29uIHdoeQ0KPj4gd2Ugc2hvdWxkIGxldCB0aGlzIG9uZSBzbGlwPw0KPiAN
Cj4gTm8sIHRoZXJlIGhhc24ndCBiZWVuIGFueSBkaXNjdXNzaW9uIHNpbmNlIHRoZSBlbWFp
bCB5b3UgcmVwbGllZCB0by4gSSd2ZSBkb25lIGEgYml0IG1vcmUgdGVzdGluZyBvbiBteSBl
bmQsIGJ1dCB3aXRob3V0IGFueXRoaW5nIGNvbmNsdXNpdmUuwqAgVGhlIG9uZSB0aGluZyBJ
IGNhbiBzYXkgaXMgdGhhdCBteSB0ZXN0aW5nIHNob3dzIHRoYXQgTFhDIGRvZXMgY29ycmVj
dGx5IGhhbmRsZSBtdWx0aS1zaG90IHBvbGwgcmVxdWVzdHMgd2hpY2ggd2VyZSBiZWluZyBk
b3duZ3JhZGVkIHRvIG9uZS1zaG90IGluIDUuMTYueCBrZXJuZWxzLCB3aGljaCBJIHRoaW5r
IGludmFsaWRhdGVzIFBhdmVsJ3MgdGhlb3J5LsKgIEluIDUuMTcueCBrZXJuZWxzLCB0aG9z
ZSBzYW1lIHBvbGwgcmVxdWVzdHMgYXJlIG5vIGxvbmdlciBiZWluZyBkb3duZ3JhZGVkIHRv
IG9uZS1zaG90IHJlcXVlc3RzLCBhbmQgdGh1cyB1bmRlciA1LjE3LnggTFhDIGlzIG5vIGxv
bmdlciByZS1hcm1pbmcgdGhvc2UgcG9sbCByZXF1ZXN0cyAoYnV0IGFsc28gc2hvdWxkbid0
IG5lZWQgdG8sIGFjY29yZGluZyB0byB3aGF0IGlzIGJlaW5nIHJldHVybmVkIGJ5IHRoZSBr
ZXJuZWwpLsKgIEkgZG9uJ3Qga25vdyBpZiB0aGlzIGNoYW5nZSBpbiBrZXJuZWwgYmVoYXZp
b3IgaXMgcmVsYXRlZCB0byB0aGUgaGFuZywgb3IgaWYgaXQgaXMganVzdCBhIHNpZGUgZWZm
ZWN0IG9mIG90aGVyIGlvLXVyaW5nIGNoYW5nZXMgdGhhdCBtYWRlIGl0IGludG8gNS4xNy7C
oCBOb3RoaW5nIGluIHRoZSBMWEMncyB1c2FnZSBvZiBpby11cmluZyBzZWVtcyBvYnZpb3Vz
bHkgaW5jb3JyZWN0IHRvIG1lLCBidXQgSSBhbSBmYXIgZnJvbSBhbiBleHBlcnQuwqAgSSBh
bHNvIGRpZCBzb21lIHdvcmsgdG93YXJkIGNyZWF0aW5nIGEgc2ltcGxlciByZXByb2R1Y2Vy
LCB3aXRob3V0IHN1Y2Nlc3MgKEkgd2FzIGFibGUgdG8gZ2V0IGEgc2ltcGxlIHByb2dyYW0g
dXNpbmcgaW8tdXJpbmcgcnVubmluZywgDQo+IGJ1dCBuZXZlciBjb3VsZCBnZXQgaXQgdG8g
aGFuZykuwqAgSVNUTSB0aGF0IHRoaXMgaXMgc3RpbGwgYSBrZXJuZWwgcmVncmVzc2lvbiwg
dW5sZXNzIHNvbWVvbmUgY2FuIHBvaW50IG91dCBhIGRlZmluaXRlIGZhdWx0IGluIHRoZSB3
YXkgTFhDIGlzIHVzaW5nIGlvLXVyaW5nLg0KDQpIYXZlbid0IGhhZCB0aW1lIHRvIGRlYnVn
IGl0LiBBcHBhcmVudGx5IExYQyBpcyBzdHVjayBvbg0KcmVhZCgyKSB0ZXJtaW5hbCBmZC4g
Tm90IHlldCBjbGVhciB3aGF0IGlzIHRoZSByZWFzb24uDQoNCi0tIA0KUGF2ZWwgQmVndW5r
b3YNCg==
