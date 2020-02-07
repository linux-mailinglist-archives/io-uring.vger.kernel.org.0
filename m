Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9133615615A
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 23:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgBGWrI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 17:47:08 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37560 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgBGWrI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 17:47:08 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so333940plz.4
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 14:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9gdbxgiI+9doXFjXyOM9X4HFb98gM1Fmo17sQ2GLv+s=;
        b=jwVhReUMYO+aOZWW9oSonbVgTY8p48f29IiGxjcoDn5f24lWAslgTy++d4cuIPplYN
         h/2hwG3zH9Ft3uPcRFHu4BbagcTOiFVj4gPKNsW6X4F6i6Mr9lEpqBpjxxibQxMEq+f2
         P9baVLYrkeydGKo7j9jeMi5KKSQ7YCg2QElIm5fuMbfGP6/S0/m2gydeQIEkNtJxlVgU
         05AWhaTqgBeL4PyNJQGqleH8kdevPQNIehL/z6VcPKEVddeYU41Ccei8LvXEeB/SEr7z
         FkQwF6a/Idsco53GnR7bxPmHjL18ngh0E42o52SHYo7WSAhKwURRDPWA1dMXzKxa4Uap
         ReEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9gdbxgiI+9doXFjXyOM9X4HFb98gM1Fmo17sQ2GLv+s=;
        b=e0ph8c7Ryc6PPPYarK/TfSJQknH33xUsin6wANQuJQL/h5gdLp1ZZDGUWzGU5PQkjS
         aMcobIcWA9fCN7Vsvoas8tfRkDZsUWI/SWEc+l4FDCtXJlP5FdteaaSNJIQYfoenUA31
         KYrF0SdTGCLAHvJ3KZGWlaZUIZ6sTvMqf4rb+FVWZHY++RmREjX7iKzZWNOr+uH0REb/
         Y26KDCYX9D6XRCh+z7EyfMpOba88TiJfLFeRZbq7mPQXeofa9sxm+U9nwhVScc7X9X3g
         mgj9HbwQ9ucOlC/kkHBIE1bYEXCTMpmVHQVI7zFfkfVdMHwABxmflf6n6s4zkN9p97RY
         86Ig==
X-Gm-Message-State: APjAAAWWbS+eKVLv+d7OR7e8MNZxHV3IQMgzN6ZfasgGrLjAnPzt7BGD
        kHkO7fKp4w0FyocNP/V6g8fikVSOD/c=
X-Google-Smtp-Source: APXvYqzPsj1ISgv0z1W0us1hiZOZLURXf/ekiiviU0hl7N2rifuCfuKGu7A/+KYNHGi8LcmxDLfzTA==
X-Received: by 2002:a17:90a:a881:: with SMTP id h1mr6472589pjq.50.1581115627750;
        Fri, 07 Feb 2020 14:47:07 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id f18sm4036761pgn.2.2020.02.07.14.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 14:47:07 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Allow relative lookups
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200207155039.12819-1-axboe@kernel.dk>
 <36ca4e5a-9ac9-2bc6-a2e6-f3e2667463c9@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <74c1e465-d18c-85f1-dd7d-1f6a7177f5a2@kernel.dk>
Date:   Fri, 7 Feb 2020 15:47:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <36ca4e5a-9ac9-2bc6-a2e6-f3e2667463c9@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/20 2:56 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> Am 07.02.20 um 16:50 schrieb Jens Axboe:
>> Due to an oversight on my part, AT_FDCWD lookups only work when the
>> lookup can be done inline, not async. This patchset rectifies that,
>> aiming for 5.6 for this one as it would be a shame to have openat etc
>> without that.
>>
>> Just 3 small simple patches - grab the task ->fs, add io-wq suppor for
>> passing it in and setting it, and finally add a ->needs_fs to the opcode
>> table list of requirements for openat/openat2/statx.
>>
>> Last patch just ensures we allow AT_FDCWD.
> 
> Thanks! But IOSQE_FIXED_FILE is still not supported and not rejected at
> the same time, correct?

That's in a separate patch:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.6&id=5e159663813f0b7837342426cfb68185b6609359

-- 
Jens Axboe

