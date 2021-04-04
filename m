Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4F1353979
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 21:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhDDT0b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 15:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhDDT0a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 15:26:30 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C8DC061756
        for <io-uring@vger.kernel.org>; Sun,  4 Apr 2021 12:26:25 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f12so3211180wro.0
        for <io-uring@vger.kernel.org>; Sun, 04 Apr 2021 12:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Ku6+bFstURKO7YQjyHG3h9R0G3jcV4aL29tgvGBy3g=;
        b=PgHDwFpHExvp8blx0PoFQfLHPQqoLLSZ83HK+BlsUs3aUnk5XgtptCDEpLaIdhH35Y
         hn2j+eV1gdf4VsMHuKurIWhCEsyWbKP+kmrQZ4DN8T9aBe3/qx3GzwfISyrCMc6lv2HS
         2i7Wz2C2bP7qXX0h/9FWEmIr3XBTTNKLMOhuiKv1E1i+kK0/ybmeEAbZgzD/jXuL9BaI
         oIsv/Z/tgndn0GXqjPR1f1LJdJa1owP2DjEvMCMbzOuf0I975hzjiKmX3aVSBbh9THe7
         OXOeBx7malKIsDWcGqYIb0LTvEIW/FOetYKiTiFE3liMq5LHSoxcjLEqiuKe7YHms2Oq
         GPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Ku6+bFstURKO7YQjyHG3h9R0G3jcV4aL29tgvGBy3g=;
        b=Q4lW8ZXO1Hv+M/YM8ll332HMlgXInrPS0wQ9VfzVde33xVINV76dtlzsLkBhaO0LBu
         Ytxbx4DRG8qdNOv+ARi63r7xE3kNRoG+1zsEpP6O0n2nttjBpF67k+CBMmN32/ekNaIb
         yIHJCBK4bo8pPx3FWJmussV+UwIWOpGkJDLtRT/vYfbCx/xF2035AMrCRC3YKNVjluB0
         NRkKaRx87CyiJBEYbrLLndcgBBlivsrQre3oK9s15nL20eak9IfBFILqZzOB7zeGB99e
         Qa4itw22u8Y0ENisXFpWwoE7LAGdp1Jyvyv07y0LZsxpaiZM98XqrPUQiVNKt5F1zsPP
         LP8g==
X-Gm-Message-State: AOAM530s1cSRWyLpfQJH/NOVsHx7lLJ8ldohKeFHOGqCec+4zWnE+Erd
        hYFdKzvQr9NuHdDC8IfzNecitOiMB6z9AA==
X-Google-Smtp-Source: ABdhPJyv0jL3v2ggzOoHIl4fMsIVBkGW+PfGs+OR1aAqmhA49+FuX760Sk2miAjLxNP3qb0KoUDYng==
X-Received: by 2002:a5d:550b:: with SMTP id b11mr26160620wrv.313.1617564384219;
        Sun, 04 Apr 2021 12:26:24 -0700 (PDT)
Received: from [192.168.8.135] ([185.69.145.138])
        by smtp.gmail.com with ESMTPSA id j23sm10423920wmo.33.2021.04.04.12.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 12:26:23 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1617287883.git.asml.silence@gmail.com>
 <66e81bc8-02ea-3f61-60e6-b7fd8acd48a2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v4 00/26] ctx wide rsrc nodes +
Message-ID: <bce0eaf1-a47d-f18a-c581-0f8b2cb8d0e3@gmail.com>
Date:   Sun, 4 Apr 2021 20:22:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <66e81bc8-02ea-3f61-60e6-b7fd8acd48a2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/04/2021 20:16, Jens Axboe wrote:
> On 4/1/21 8:43 AM, Pavel Begunkov wrote:
>> 1-7 implement ctx wide rsrc nodes. The main idea here is to make make
>> rsrc nodes (aka ref nodes) to be per ctx rather than per rsrc_data, that
>> is a requirement for having multiple resource types. All the meat to it
>> in 7/7. Btw improve rsrc API, because it was too easy to misuse.
>>
>> Others are further cleanups
> 
> Applied 1-9, and 10-26 - #10 needs some love with the recent changes.

Perfect, thanks. Was rebasing and testing myself.

#10 is not needed at all now, so let's keep it dropped

-- 
Pavel Begunkov
