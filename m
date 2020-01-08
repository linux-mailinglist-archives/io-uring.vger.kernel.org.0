Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E61D3134A34
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2020 19:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgAHSIc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jan 2020 13:08:32 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39451 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgAHSIc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jan 2020 13:08:32 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so1435105plp.6
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2020 10:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gzLm2vqAr/e01LCTk+6wCwI/DooZbP5D84mNaOT3XPA=;
        b=i8TZUkadLSltjUtY2tnV1XRlMBmKcWPr9/SWDLqn1nJoSKSFXqWdSLoWeKc8vW5lnQ
         ynk68qWfKICPzYet/Ru2FNU3rBpfA6zVvIIbLvOTcfp7xPEXRiDeJPuq+idQPQBRowcZ
         mHtwFXFUEj2m4+BDT1rqzJZXwkFcb8jHTQRf9c0Ki/bjqlC+aMhS+CEDgtx5trktN4WW
         F0Ly5SCDRtUy2dcOwTYNngQ1vuyhLDypQDsv4C2/B/UNhMBCsde6LUQupr5NkWBBTuOf
         xjpB6SEeN+4XpBc2r1J8lTST0WEwjQ6VevTIQz89O7TjEpnCLw/0hMJN09tLT26XrZYj
         UJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gzLm2vqAr/e01LCTk+6wCwI/DooZbP5D84mNaOT3XPA=;
        b=EdY9VitVBXUDfJHxVMtjkRgJg9drgWyo1tLam8/lwn/3vuCfdhROujbQGId7UCW4t/
         ocFhbGY3fSH1pqrqCyVAyxSx3WeHQQ3dsApeTfdkJTyYYy0itreHClJ4fZS/Ka11bE2l
         rsqrcmFq/TLgXWbckxa16MWaTgtW99eu4QCvd+yZbEfd80UhIxwGx+h7Ow/6vgmo97lk
         ohnTYi8OpuTteXLBDCPwzOa3Je55+8szTk6PurRup4nwONWrJfu86lgoqxTBpGaCfMMn
         chWqNMCOXfkIpsTy1pRHT6hA1QOt0QgJmqYE1ZuQAMELAIA2hgMTO34Xec54DSKTMilh
         HG7g==
X-Gm-Message-State: APjAAAUFaG+ObJMgtVEPUZluaa8dF/QmqxY2gDKGw1fXwFzBvrIH7dyG
        RIAqOhCbWLfmdeIQd4a0kQqBkA9GXBw=
X-Google-Smtp-Source: APXvYqxiMhCwT2kxI+5D/FTubvfN1RyeTZGDWAThPLNNdQsPuYpWhVso8dXIIliNCvNq2EjKITGX7Q==
X-Received: by 2002:a17:90a:200d:: with SMTP id n13mr5954103pjc.16.1578506910812;
        Wed, 08 Jan 2020 10:08:30 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id k3sm4429467pgc.3.2020.01.08.10.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 10:08:30 -0800 (PST)
Subject: Re: io_uring and spurious wake-ups from eventfd
From:   Jens Axboe <axboe@kernel.dk>
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     io-uring@vger.kernel.org
References: <d949ea3a-bd24-e597-b230-89b7075544cc@kernel.dk>
 <02106C23-C466-4E63-B881-AF8E6BDF9235@icloud.com>
 <f0c6bab5-3fd3-a3c5-8924-62adb419a865@kernel.dk>
 <d1ac6188-2ea4-6dbc-b7d9-02ee356400e7@kernel.dk>
Message-ID: <c3ec219d-9b65-49bc-28fd-911c878688f5@kernel.dk>
Date:   Wed, 8 Jan 2020 11:08:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d1ac6188-2ea4-6dbc-b7d9-02ee356400e7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/8/20 10:20 AM, Jens Axboe wrote:
> On 1/8/20 9:50 AM, Jens Axboe wrote:
>> On 1/8/20 9:46 AM, Mark Papadakis wrote:
>>> Thus sounds perfect!
>>
>> I'll try and cook this up, if you can test it.
> 
> Something like the below.

I pushed it here for easier testing:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs

-- 
Jens Axboe

