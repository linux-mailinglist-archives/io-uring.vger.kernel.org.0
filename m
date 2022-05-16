Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66165528551
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 15:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbiEPN1z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 09:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243988AbiEPN01 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 09:26:27 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BA22622;
        Mon, 16 May 2022 06:26:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k30so7829940wrd.5;
        Mon, 16 May 2022 06:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=kd7YyEIP4Ym1FPKvape900TtopigPTFUZt8/kT7lxG4=;
        b=BMGuC+DDYMdTNxETbmOjEYEkvLWb1/foWdGSyTORyaBuRRH/Jcv5q2FczB6H1eOTu2
         p7CZeGQjOMIhVeRNBcLJ7rqQauoMcqENd8pLZl1LIyl5ZNXYA8qTZ+hZZUylqpopZf5O
         lsZeA+jSXS7v4Zn1nqcYpEGz5JnFKbCjf5P5D2ba+PrVXzM+eH6I7iXset65WS7jS412
         /MwesLFD/6IF3OCQF8022nZUPtDfQl590ELWbcJULNQfxHJ+76J6BF+p55X19i5vlxIY
         3OJ5SOvhFxCBjlM104x4zq3WSo/SxxqfQ5YjJbpRKLPRh+wQLSpxuQGiEQgegaTJgSbl
         gv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=kd7YyEIP4Ym1FPKvape900TtopigPTFUZt8/kT7lxG4=;
        b=V6k11MJsr93B15W5vKxUGcM/9oJtmHMuu6Pv7Ujv/FYR+F+TwDWHcIwWugBBshzymr
         t+K4WZI0uP4XYrpHT+EXPAB18uT8TwWHxxygyJxR+cR2x0y2oTrLu6JCC4vQc25MYZvg
         MYQLQFORXNBNF289hMhHI6xVy9BEkqsDridZXBHq9QmpZX3oITkgH9C44nedtNQKpHnr
         DABURT++26e5nLL/5mEMBcIvogOu0OT1CLjom07xka9oMbvrxrWpva5BJtBlBJFrE2cl
         XXGymdn8cKTW3TD6udWId6nsMrvHNpE0Ejh9+tmcN0Zh9vZ+83xk/MG3aiALeggwWIpl
         cZOA==
X-Gm-Message-State: AOAM533WueKvF48+Rvd2badG5vqwi3pwjqYLJ4QTa/M2PkugZlsLpuxS
        cfCdvI64/+7e2g/Gvp7KwM0=
X-Google-Smtp-Source: ABdhPJxTeODjQbVpHNKYrXKM2XXRc7q1mtDqeWdzed1ri6+7FED4kCsCsa9xe58oKL4KKLv93XZ6Mg==
X-Received: by 2002:adf:d239:0:b0:20d:491:75fd with SMTP id k25-20020adfd239000000b0020d049175fdmr5849635wrh.195.1652707584343;
        Mon, 16 May 2022 06:26:24 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.232.94])
        by smtp.gmail.com with ESMTPSA id p21-20020a05600c359500b00394755b4479sm14976314wmq.21.2022.05.16.06.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 06:26:23 -0700 (PDT)
Message-ID: <da56fa5f-0624-413e-74a1-545993940d27@gmail.com>
Date:   Mon, 16 May 2022 14:25:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Daniel Harding <dharding@living180.net>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Jens Axboe <axboe@kernel.dk>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
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
 <41c86189-0d1f-60f0-ca8e-f80b3ccf5130@gmail.com>
In-Reply-To: <41c86189-0d1f-60f0-ca8e-f80b3ccf5130@gmail.com>
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

T24gNS8xNi8yMiAxMzoxMiwgUGF2ZWwgQmVndW5rb3Ygd3JvdGU6DQo+IE9uIDUvMTUvMjIg
MTk6MzQsIERhbmllbCBIYXJkaW5nIHdyb3RlOg0KPj4gT24gNS8xNS8yMiAxMToyMCwgVGhv
cnN0ZW4gTGVlbWh1aXMgd3JvdGU6DQo+Pj4gT24gMDQuMDUuMjIgMDg6NTQsIERhbmllbCBI
YXJkaW5nIHdyb3RlOg0KPj4+PiBPbiA1LzMvMjIgMTc6MTQsIFBhdmVsIEJlZ3Vua292IHdy
b3RlOg0KPj4+Pj4gT24gNS8zLzIyIDA4OjM3LCBEYW5pZWwgSGFyZGluZyB3cm90ZToNCj4+
Pj4+PiBbUmVzZW5kIHdpdGggYSBzbWFsbGVyIHRyYWNlXQ0KPj4+Pj4+IE9uIDUvMy8yMiAw
MjoxNCwgUGF2ZWwgQmVndW5rb3Ygd3JvdGU6DQo+Pj4+Pj4+IE9uIDUvMi8yMiAxOTo0OSwg
RGFuaWVsIEhhcmRpbmcgd3JvdGU6DQo+Pj4+Pj4+PiBPbiA1LzIvMjIgMjA6NDAsIFBhdmVs
IEJlZ3Vua292IHdyb3RlOg0KPj4+Pj4+Pj4+IE9uIDUvMi8yMiAxODowMCwgSmVucyBBeGJv
ZSB3cm90ZToNCj4+Pj4+Pj4+Pj4gT24gNS8yLzIyIDc6NTkgQU0sIEplbnMgQXhib2Ugd3Jv
dGU6DQo+Pj4+Pj4+Pj4+PiBPbiA1LzIvMjIgNzozNiBBTSwgRGFuaWVsIEhhcmRpbmcgd3Jv
dGU6DQo+Pj4+Pj4+Pj4+Pj4gT24gNS8yLzIyIDE2OjI2LCBKZW5zIEF4Ym9lIHdyb3RlOg0K
Pj4+Pj4+Pj4+Pj4+PiBPbiA1LzIvMjIgNzoxNyBBTSwgRGFuaWVsIEhhcmRpbmcgd3JvdGU6
DQo+Pj4+Pj4+Pj4+Pj4+PiBJIHVzZSBseGMtNC4wLjEyIG9uIEdlbnRvbywgYnVpbHQgd2l0
aCBpby11cmluZyBzdXBwb3J0DQo+Pj4+Pj4+Pj4+Pj4+PiAoLS1lbmFibGUtbGlidXJpbmcp
LCB0YXJnZXRpbmcgbGlidXJpbmctMi4xLsKgIE15IGtlcm5lbA0KPj4+Pj4+Pj4+Pj4+Pj4g
Y29uZmlnIGlzIGENCj4+Pj4+Pj4+Pj4+Pj4+IHZlcnkgbGlnaHRseSBtb2RpZmllZCB2ZXJz
aW9uIG9mIEZlZG9yYSdzIGdlbmVyaWMga2VybmVsDQo+Pj4+Pj4+Pj4+Pj4+PiBjb25maWcu
IEFmdGVyDQo+Pj4+Pj4+Pj4+Pj4+PiBtb3ZpbmcgZnJvbSB0aGUgNS4xNi54IHNlcmllcyB0
byB0aGUgNS4xNy54IGtlcm5lbCBzZXJpZXMsIEkNCj4+Pj4+Pj4+Pj4+Pj4+IHN0YXJ0ZWQN
Cj4+Pj4+Pj4+Pj4+Pj4+IG5vdGljZWQgZnJlcXVlbnQgaGFuZ3MgaW4gbHhjLXN0b3AuwqAg
SXQgZG9lc24ndCBoYXBwZW4gMTAwJQ0KPj4+Pj4+Pj4+Pj4+Pj4gb2YgdGhlDQo+Pj4+Pj4+
Pj4+Pj4+PiB0aW1lLCBidXQgZGVmaW5pdGVseSBtb3JlIHRoYW4gNTAlIG9mIHRoZSB0aW1l
LiBCaXNlY3RpbmcNCj4+Pj4+Pj4+Pj4+Pj4+IG5hcnJvd2VkDQo+Pj4+Pj4+Pj4+Pj4+PiBk
b3duIHRoZSBpc3N1ZSB0byBjb21taXQNCj4+Pj4+Pj4+Pj4+Pj4+IGFhNDM0NzdiMDQwMjUx
ZjQ1MWRiMGQ4NDQwNzNhYzAwYThhYjY2ZWU6DQo+Pj4+Pj4+Pj4+Pj4+PiBpb191cmluZzog
cG9sbCByZXdvcmsuIFRlc3RpbmcgaW5kaWNhdGVzIHRoZSBwcm9ibGVtIGlzIHN0aWxsDQo+
Pj4+Pj4+Pj4+Pj4+PiBwcmVzZW50DQo+Pj4+Pj4+Pj4+Pj4+PiBpbiA1LjE4LXJjNS4gVW5m
b3J0dW5hdGVseSBJIGRvIG5vdCBoYXZlIHRoZSBleHBlcnRpc2Ugd2l0aCB0aGUNCj4+Pj4+
Pj4+Pj4+Pj4+IGNvZGViYXNlcyBvZiBlaXRoZXIgbHhjIG9yIGlvLXVyaW5nIHRvIHRyeSB0
byBkZWJ1ZyB0aGUgcHJvYmxlbQ0KPj4+Pj4+Pj4+Pj4+Pj4gZnVydGhlciBvbiBteSBvd24s
IGJ1dCBJIGNhbiBlYXNpbHkgYXBwbHkgcGF0Y2hlcyB0byBhbnkgb2YgdGhlDQo+Pj4+Pj4+
Pj4+Pj4+PiBpbnZvbHZlZCBjb21wb25lbnRzIChseGMsIGxpYnVyaW5nLCBrZXJuZWwpIGFu
ZCByZWJ1aWxkIGZvcg0KPj4+Pj4+Pj4+Pj4+Pj4gdGVzdGluZyBvcg0KPj4+Pj4+Pj4+Pj4+
Pj4gdmFsaWRhdGlvbi7CoCBJIGFtIGFsc28gaGFwcHkgdG8gcHJvdmlkZSBhbnkgZnVydGhl
cg0KPj4+Pj4+Pj4+Pj4+Pj4gaW5mb3JtYXRpb24gdGhhdA0KPj4+Pj4+Pj4+Pj4+Pj4gd291
bGQgYmUgaGVscGZ1bCB3aXRoIHJlcHJvZHVjaW5nIG9yIGRlYnVnZ2luZyB0aGUgcHJvYmxl
bS4NCj4+Pj4+Pj4+Pj4+Pj4gRG8geW91IGhhdmUgYSByZWNpcGUgdG8gcmVwcm9kdWNlIHRo
ZSBoYW5nPyBUaGF0IHdvdWxkIG1ha2UgaXQNCj4+Pj4+Pj4+Pj4+Pj4gc2lnbmlmaWNhbnRs
eSBlYXNpZXIgdG8gZmlndXJlIG91dC4NCj4+Pj4+Pj4+Pj4+PiBJIGNhbiByZXByb2R1Y2Ug
aXQgd2l0aCBqdXN0IHRoZSBmb2xsb3dpbmc6DQo+Pj4+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+Pj4+
PiDCoMKgwqDCoMKgIHN1ZG8gbHhjLWNyZWF0ZSAtLW4gbHhjLXRlc3QgLS10ZW1wbGF0ZSBk
b3dubG9hZCAtLWJkZXYNCj4+Pj4+Pj4+Pj4+PiBkaXIgLS1kaXIgL3Zhci9saWIvbHhjL2x4
Yy10ZXN0L3Jvb3RmcyAtLSAtZCB1YnVudHUgLXIgYmlvbmljDQo+Pj4+Pj4+Pj4+Pj4gLWEg
YW1kNjQNCj4+Pj4+Pj4+Pj4+PiDCoMKgwqDCoMKgIHN1ZG8gbHhjLXN0YXJ0IC1uIGx4Yy10
ZXN0DQo+Pj4+Pj4+Pj4+Pj4gwqDCoMKgwqDCoCBzdWRvIGx4Yy1zdG9wIC1uIGx4Yy10ZXN0
DQo+Pj4+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+Pj4+PiBUaGUgbHhjLXN0b3AgY29tbWFuZCBuZXZl
ciBleGl0cyBhbmQgdGhlIGNvbnRhaW5lciBjb250aW51ZXMNCj4+Pj4+Pj4+Pj4+PiBydW5u
aW5nLg0KPj4+Pj4+Pj4+Pj4+IElmIHRoYXQgaXNuJ3Qgc3VmZmljaWVudCB0byByZXByb2R1
Y2UsIHBsZWFzZSBsZXQgbWUga25vdy4NCj4+Pj4+Pj4+Pj4+IFRoYW5rcywgdGhhdCdzIHVz
ZWZ1bCEgSSdtIGF0IGEgY29uZmVyZW5jZSB0aGlzIHdlZWsgYW5kIGhlbmNlIGhhdmUNCj4+
Pj4+Pj4+Pj4+IGxpbWl0ZWQgYW1vdW50IG9mIHRpbWUgdG8gZGVidWcsIGhvcGVmdWxseSBQ
YXZlbCBoYXMgdGltZSB0bw0KPj4+Pj4+Pj4+Pj4gdGFrZSBhIGxvb2sNCj4+Pj4+Pj4+Pj4+
IGF0IHRoaXMuDQo+Pj4+Pj4+Pj4+IERpZG4ndCBtYW5hZ2UgdG8gcmVwcm9kdWNlLiBDYW4g
eW91IHRyeSwgb24gYm90aCB0aGUgZ29vZCBhbmQgYmFkDQo+Pj4+Pj4+Pj4+IGtlcm5lbCwg
dG8gZG86DQo+Pj4+Pj4+Pj4gU2FtZSBoZXJlLCBpdCBkb2Vzbid0IHJlcHJvZHVjZSBmb3Ig
bWUNCj4+Pj4+Pj4+IE9LLCBzb3JyeSBpdCB3YXNuJ3Qgc29tZXRoaW5nIHNpbXBsZS4NCj4+
Pj4+Pj4+PiAjIGVjaG8gMSA+IC9zeXMva2VybmVsL2RlYnVnL3RyYWNpbmcvZXZlbnRzL2lv
X3VyaW5nL2VuYWJsZQ0KPj4+Pj4+Pj4+PiBydW4gbHhjLXN0b3ANCj4+Pj4+Pj4+Pj4NCj4+
Pj4+Pj4+Pj4gIyBjcCAvc3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5nL3RyYWNlIH4vaW91LXRy
YWNlDQo+Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4+IHNvIHdlIGNhbiBzZWUgd2hhdCdzIGdvaW5n
IG9uPyBMb29raW5nIGF0IHRoZSBzb3VyY2UsIGx4YyBpcyBqdXN0DQo+Pj4+Pj4+Pj4+IHVz
aW5nDQo+Pj4+Pj4+Pj4+IHBsYWluIFBPTExfQURELCBzbyBJJ20gZ3Vlc3NpbmcgaXQncyBu
b3QgZ2V0dGluZyBhIG5vdGlmaWNhdGlvbg0KPj4+Pj4+Pj4+PiB3aGVuIGl0DQo+Pj4+Pj4+
Pj4+IGV4cGVjdHMgdG8sIG9yIGl0J3MgUE9MTF9SRU1PVkUgbm90IGRvaW5nIGl0cyBqb2Iu
IElmIHdlIGhhdmUgYQ0KPj4+Pj4+Pj4+PiB0cmFjZQ0KPj4+Pj4+Pj4+PiBmcm9tIGJvdGgg
YSB3b3JraW5nIGFuZCBicm9rZW4ga2VybmVsLCB0aGF0IG1pZ2h0IHNoZWQgc29tZSBsaWdo
dA0KPj4+Pj4+Pj4+PiBvbiBpdC4NCj4+Pj4+Pj4+IEl0J3MgbGF0ZSBpbiBteSB0aW1lem9u
ZSwgYnV0IEknbGwgdHJ5IHRvIHdvcmsgb24gZ2V0dGluZyB0aG9zZQ0KPj4+Pj4+Pj4gdHJh
Y2VzIHRvbW9ycm93Lg0KPj4+Pj4+PiBJIHRoaW5rIEkgZ290IGl0LCBJJ3ZlIGF0dGFjaGVk
IGEgdHJhY2UuDQo+Pj4+Pj4+DQo+Pj4+Pj4+IFdoYXQncyBpbnRlcmVzdGluZyBpcyB0aGF0
IGl0IGlzc3VlcyBhIG11bHRpIHNob3QgcG9sbCBidXQgSSBkb24ndA0KPj4+Pj4+PiBzZWUg
YW55IGtpbmQgb2YgY2FuY2VsbGF0aW9uLCBuZWl0aGVyIGNhbmNlbCByZXF1ZXN0cyBub3Ig
dGFzay9yaW5nDQo+Pj4+Pj4+IGV4aXQuIFBlcmhhcHMgaGF2ZSB0byBnbyBsb29rIGF0IGx4
YyB0byBzZWUgaG93IGl0J3Mgc3VwcG9zZWQNCj4+Pj4+Pj4gdG8gd29yaw0KPj4+Pj4+IFll
cywgdGhhdCBsb29rcyBleGFjdGx5IGxpa2UgbXkgYmFkIHRyYWNlLsKgIEkndmUgYXR0YWNo
ZWQgZ29vZCB0cmFjZQ0KPj4+Pj4+IChjYXB0dXJlZCB3aXRoIGxpbnV4LTUuMTYuMTkpIGFu
ZCBhIGJhZCB0cmFjZSAoY2FwdHVyZWQgd2l0aA0KPj4+Pj4+IGxpbnV4LTUuMTcuNSkuwqAg
VGhlc2UgYXJlIHRoZSBkaWZmZXJlbmNlcyBJIG5vdGljZWQgd2l0aCBqdXN0IGENCj4+Pj4+
PiB2aXN1YWwgc2NhbjoNCj4+Pj4+Pg0KPj4+Pj4+ICogQm90aCB0cmFjZXMgaGF2ZSB0aHJl
ZSBpb191cmluZ19zdWJtaXRfc3FlIGNhbGxzIGF0IHRoZSB2ZXJ5DQo+Pj4+Pj4gYmVnaW5u
aW5nLCBidXQgaW4gdGhlIGdvb2QgdHJhY2UsIHRoZXJlIGFyZSBmdXJ0aGVyDQo+Pj4+Pj4g
aW9fdXJpbmdfc3VibWl0X3NxZSBjYWxscyB0aHJvdWdob3V0IHRoZSB0cmFjZSwgd2hpbGUg
aW4gdGhlIGJhZA0KPj4+Pj4+IHRyYWNlLCB0aGVyZSBhcmUgbm9uZS4NCj4+Pj4+PiAqIFRo
ZSBnb29kIHRyYWNlIHVzZXMgYSBtYXNrIG9mIGMzIGZvciBpb191cmluZ190YXNrX2FkZCBt
dWNoIG1vcmUNCj4+Pj4+PiBvZnRlbiB0aGFuIHRoZSBiYWQgdHJhY2U6wqAgdGhlIGJhZCB0
cmFjZSB1c2VzIGEgbWFzayBvZiBjMyBvbmx5IGZvcg0KPj4+Pj4+IHRoZSB2ZXJ5IGxhc3Qg
Y2FsbCB0byBpb191cmluZ190YXNrX2FkZCwgYnV0IGEgbWFzayBvZiA0MSBmb3IgdGhlDQo+
Pj4+Pj4gb3RoZXIgY2FsbHMuDQo+Pj4+Pj4gKiBJbiB0aGUgZ29vZCB0cmFjZSwgbWFueSBv
ZiB0aGUgaW9fdXJpbmdfY29tcGxldGUgY2FsbHMgaGF2ZSBhDQo+Pj4+Pj4gcmVzdWx0IG9m
IDE5NSwgd2hpbGUgaW4gdGhlIGJhZCB0cmFjZSwgdGhleSBhbGwgaGF2ZSBhIHJlc3VsdCBv
ZiAxLg0KPj4+Pj4+DQo+Pj4+Pj4gSSBkb24ndCBrbm93IHdoZXRoZXIgYW55IG9mIHRob3Nl
IHRoaW5ncyBhcmUgc2lnbmlmaWNhbnQgb3Igbm90LCBidXQNCj4+Pj4+PiB0aGF0J3Mgd2hh
dCBqdW1wZWQgb3V0IGF0IG1lLg0KPj4+Pj4+DQo+Pj4+Pj4gSSBoYXZlIGFsc28gYXR0YWNo
ZWQgYSBjb3B5IG9mIHRoZSBzY3JpcHQgSSB1c2VkIHRvIGdlbmVyYXRlIHRoZQ0KPj4+Pj4+
IHRyYWNlcy7CoCBJZiB0aGVyZSBpcyBhbnl0aGluZyBmdXJ0aGVyIEkgY2FuIHRvIGRvIGhl
bHAgZGVidWcsIHBsZWFzZQ0KPj4+Pj4+IGxldCBtZSBrbm93Lg0KPj4+Pj4gR29vZCBvYnNl
cnZhdGlvbnMhIHRoYW5rcyBmb3IgdHJhY2VzLg0KPj4+Pj4NCj4+Pj4+IEl0IHNvdW5kcyBs
aWtlIG11bHRpLXNob3QgcG9sbCByZXF1ZXN0cyB3ZXJlIGdldHRpbmcgZG93bmdyYWRlZA0K
Pj4+Pj4gdG8gb25lLXNob3QsIHdoaWNoIGlzIGEgdmFsaWQgYmVoYXZpb3VyIGFuZCB3YXMg
c28gYmVjYXVzZSB3ZQ0KPj4+Pj4gZGlkbid0IGZ1bGx5IHN1cHBvcnQgc29tZSBjYXNlcy4g
SWYgdGhhdCdzIHRoZSByZWFzb24sIHRoYW4NCj4+Pj4+IHRoZSB1c2Vyc3BhY2UvbHhjIGlz
IG1pc3VzaW5nIHRoZSBBQkkuIEF0IGxlYXN0LCB0aGF0J3MgdGhlDQo+Pj4+PiB3b3JraW5n
IGh5cG90aGVzaXMgZm9yIG5vdywgbmVlZCB0byBjaGVjayBseGMuDQo+Pj4+IFNvLCBJIGxv
b2tlZCBhdCB0aGUgbHhjIHNvdXJjZSBjb2RlLCBhbmQgaXQgYXBwZWFycyB0byBhdCBsZWFz
dCB0cnkgdG8NCj4+Pj4gaGFuZGxlIHRoZSBjYXNlIG9mIG11bHRpLXNob3QgYmVpbmcgZG93
bmdyYWRlZCB0byBvbmUtc2hvdC7CoCBJIGRvbid0DQo+Pj4+IGtub3cgZW5vdWdoIHRvIGtu
b3cgaWYgdGhlIGNvZGUgaXMgYWN0dWFsbHkgY29ycmVjdCBob3dldmVyOg0KPj4+Pg0KPj4+
PiBodHRwczovL2dpdGh1Yi5jb20vbHhjL2x4Yy9ibG9iLzdlMzdjYzk2YmI5NDE3NWE4ZTM1
MTAyNWQyNmNjMzVkYzJkMTA1NDMvc3JjL2x4Yy9tYWlubG9vcC5jI0wxNjUtTDE4OQ0KPj4+
PiBodHRwczovL2dpdGh1Yi5jb20vbHhjL2x4Yy9ibG9iLzdlMzdjYzk2YmI5NDE3NWE4ZTM1
MTAyNWQyNmNjMzVkYzJkMTA1NDMvc3JjL2x4Yy9tYWlubG9vcC5jI0wyNTQNCj4+Pj4gaHR0
cHM6Ly9naXRodWIuY29tL2x4Yy9seGMvYmxvYi83ZTM3Y2M5NmJiOTQxNzVhOGUzNTEwMjVk
MjZjYzM1ZGMyZDEwNTQzL3NyYy9seGMvbWFpbmxvb3AuYyNMMjg4LUwyOTANCj4+PiBIaSwg
dGhpcyBpcyB5b3VyIExpbnV4IGtlcm5lbCByZWdyZXNzaW9uIHRyYWNrZXIuIE5vdGhpbmcg
aGFwcGVuZWQgaGVyZQ0KPj4+IGZvciByb3VuZCBhYm91dCB0ZW4gZGF5cyBub3cgYWZhaWNz
OyBvciBkaWQgdGhlIGRpc2N1c3Npb24gY29udGludWUNCj4+PiBzb21ld2hlcmUgZWxzZS4N
Cj4+Pg0KPj4+IMKgRnJvbSB3aGF0IEkgZ2F0aGVyZWQgZnJvbSB0aGlzIGRpc2N1c3Npb24g
aXMgc2VlbXMgdGhlIHJvb3QgY2F1c2UgbWlnaHQNCj4+PiBiZSBpbiBMWEMsIGJ1dCBpdCB3
YXMgZXhwb3NlZCBieSBrZXJuZWwgY2hhbmdlLiBUaGF0IG1ha2VzIGl0IHNpbGwgYQ0KPj4+
IGtlcm5lbCByZWdyZXNzaW9uIHRoYXQgc2hvdWxkIGJlIGZpeGVkOyBvciBpcyB0aGVyZSBh
IHN0cm9uZyByZWFzb24gd2h5DQo+Pj4gd2Ugc2hvdWxkIGxldCB0aGlzIG9uZSBzbGlwPw0K
Pj4NCj4+IE5vLCB0aGVyZSBoYXNuJ3QgYmVlbiBhbnkgZGlzY3Vzc2lvbiBzaW5jZSB0aGUg
ZW1haWwgeW91IHJlcGxpZWQgdG8uIEkndmUgZG9uZSBhIGJpdCBtb3JlIHRlc3Rpbmcgb24g
bXkgZW5kLCBidXQgd2l0aG91dCBhbnl0aGluZyBjb25jbHVzaXZlLsKgIFRoZSBvbmUgdGhp
bmcgSSBjYW4gc2F5IGlzIHRoYXQgbXkgdGVzdGluZyBzaG93cyB0aGF0IExYQyBkb2VzIGNv
cnJlY3RseSBoYW5kbGUgbXVsdGktc2hvdCBwb2xsIHJlcXVlc3RzIHdoaWNoIHdlcmUgYmVp
bmcgZG93bmdyYWRlZCB0byBvbmUtc2hvdCBpbiA1LjE2Lngga2VybmVscywgd2hpY2ggSSB0
aGluayBpbnZhbGlkYXRlcyBQYXZlbCdzIHRoZW9yeS7CoCBJbiA1LjE3Lngga2VybmVscywg
dGhvc2Ugc2FtZSBwb2xsIHJlcXVlc3RzIGFyZSBubyBsb25nZXIgYmVpbmcgZG93bmdyYWRl
ZCB0byBvbmUtc2hvdCByZXF1ZXN0cywgYW5kIHRodXMgdW5kZXIgNS4xNy54IExYQyBpcyBu
byBsb25nZXIgcmUtYXJtaW5nIHRob3NlIHBvbGwgcmVxdWVzdHMgKGJ1dCBhbHNvIHNob3Vs
ZG4ndCBuZWVkIHRvLCBhY2NvcmRpbmcgdG8gd2hhdCBpcyBiZWluZyByZXR1cm5lZCBieSB0
aGUga2VybmVsKS7CoCBJIGRvbid0IGtub3cgaWYgdGhpcyBjaGFuZ2UgaW4ga2VybmVsIGJl
aGF2aW9yIGlzIHJlbGF0ZWQgdG8gdGhlIGhhbmcsIG9yIGlmIGl0IGlzIGp1c3QgYSBzaWRl
IGVmZmVjdCBvZiBvdGhlciBpby11cmluZyBjaGFuZ2VzIHRoYXQgbWFkZSBpdCBpbnRvIDUu
MTcuwqAgTm90aGluZyBpbiB0aGUgTFhDJ3MgdXNhZ2Ugb2YgaW8tdXJpbmcgc2VlbXMgb2J2
aW91c2x5IGluY29ycmVjdCB0byBtZSwgYnV0IEkgYW0gZmFyIGZyb20gYW4gZXhwZXJ0LsKg
IEkgYWxzbyBkaWQgc29tZSB3b3JrIHRvd2FyZCBjcmVhdGluZyBhIHNpbXBsZXIgcmVwcm9k
dWNlciwgd2l0aG91dCBzdWNjZXNzIChJIHdhcyBhYmxlIHRvIGdldCBhIHNpbXBsZSBwcm9n
cmFtIHVzaW5nIGlvLXVyaW5nIHJ1bm5pbmcsIA0KPj4gYnV0IG5ldmVyIGNvdWxkIGdldCBp
dCB0byBoYW5nKS7CoCBJU1RNIHRoYXQgdGhpcyBpcyBzdGlsbCBhIGtlcm5lbCByZWdyZXNz
aW9uLCB1bmxlc3Mgc29tZW9uZSBjYW4gcG9pbnQgb3V0IGEgZGVmaW5pdGUgZmF1bHQgaW4g
dGhlIHdheSBMWEMgaXMgdXNpbmcgaW8tdXJpbmcuDQo+IA0KPiBIYXZlbid0IGhhZCB0aW1l
IHRvIGRlYnVnIGl0LiBBcHBhcmVudGx5IExYQyBpcyBzdHVjayBvbg0KPiByZWFkKDIpIHRl
cm1pbmFsIGZkLiBOb3QgeWV0IGNsZWFyIHdoYXQgaXMgdGhlIHJlYXNvbi4NCg0KSG93IGl0
IHdhcyB3aXRoIG9uZXNob3RzOg0KDQoxOiBrZXJuZWw6IHBvbGwgZmlyZXMsIGFkZCBhIENR
RQ0KMjoga2VybmVsOiByZW1vdmUgcG9sbA0KMzogdXNlcnNwYWNlOiBnZXQgQ1FFDQo0OiB1
c2Vyc3BhY2U6IHJlYWQodGVybWluYWxfZmQpOw0KNTogdXNlcnNwYWNlOiBhZGQgbmV3IHBv
bGwNCjY6IGdvdG8gMSkNCg0KV2hhdCBtaWdodCBoYXBwZW4gYW5kIGFjdHVhbGx5IGhhcHBl
bnMgd2l0aCBtdWx0aXNob3Q6DQoNCjE6IGtlcm5lbDogcG9sbCBmaXJlcywgYWRkIENRRTEN
CjI6IGtlcm5lbDogcG9sbCBmaXJlcyBhZ2FpbiwgYWRkIENRRTINCjM6IHVzZXJzcGFjZTog
Z2V0IENRRTENCjQ6IHVzZXJzcGFjZTogcmVhZCh0ZXJtaW5hbF9mZCk7IC8vIHJlYWRzIGFs
bCBkYXRhLCBmb3IgYm90aCBDUUUxIGFuZCBDUUUyDQo1OiB1c2Vyc3BhY2U6IGdldCBDUUUy
DQo2OiB1c2Vyc3BhY2U6IHJlYWQodGVybWluYWxfZmQpOyAvLyBub3RoaW5nIHRvIHJlYWQs
IGhhbmdzIGhlcmUNCg0KSXQgc2hvdWxkIGJlIHRoZSByZWFkIGluIGx4Y190ZXJtaW5hbF9w
dHhfaW8oKS4NCg0KSU1ITywgaXQncyBub3QgYSByZWdyZXNzaW9uIGJ1dCBhIG5vdCBwZXJm
ZWN0IGZlYXR1cmUgQVBJIGFuZC9vcg0KYW4gQVBJIG1pc3VzZS4NCg0KQ2M6IENocmlzdGlh
biBCcmF1bmVyDQoNCkNocmlzdGlhbiwgaW4gY2FzZSB5b3UgbWF5IGhhdmUgc29tZSBpbnB1
dCBvbiB0aGUgTFhDIHNpZGUgb2YgdGhpbmdzLg0KRGFuaWVsIHJlcG9ydGVkIGFuIExYQyBw
cm9ibGVtIHdoZW4gaXQgdXNlcyBpb191cmluZyBtdWx0aXNob3QgcG9sbCByZXF1ZXN0cy4N
CkJlZm9yZSBhYTQzNDc3YjA0MDI1ICgiaW9fdXJpbmc6IHBvbGwgcmV3b3JrIiksIG11bHRp
c2hvdCBwb2xsIHJlcXVlc3RzIGZvcg0KdHR5L3B0eSBhbmQgc29tZSBvdGhlciBmaWxlcyB3
ZXJlIGFsd2F5cyBkb3duZ3JhZGVkIHRvIG9uZXNob3RzLCB3aGljaCBoYWQNCmJlZW4gZml4
ZWQgYnkgdGhlIGNvbW1pdCBhbmQgZXhwb3NlZCB0aGUgcHJvYmxlbS4gSSBob3BlIHRoZSBl
eGFtcGxlIGFib3ZlDQpleHBsYWlucyBpdCwgYnV0IHBsZWFzZSBsZXQgbWUga25vdyBpZiBp
dCBuZWVkcyBtb3JlIGRldGFpbHMNCg0KLS0gDQpQYXZlbCBCZWd1bmtvdg0K
