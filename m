Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A4D134872
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2020 17:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgAHQuS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jan 2020 11:50:18 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:34623 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgAHQuS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jan 2020 11:50:18 -0500
Received: by mail-pf1-f176.google.com with SMTP id i6so1919249pfc.1
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2020 08:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sva5Znt/VDeW7J0KbuIeEzKeZPgyEyCu17zk6tnMZBc=;
        b=srdMp++kiAYQq1bIhybd2X+vY58d724lJOygBdGj8ArzUWh+WMnw6MaVn4pgkZmS9J
         1LN0PV6k46uyrtBDysEi8wZGkR8Qg9W3WidPsIGzHvPy7GtbO7IAs7QMN2kbd9gwq6CS
         SaxNCO1kkbfgNkQJTLbirDUI2sLP0rhf5RkaIJIrrkm/pN3qjLjdO3WuP/A2muA9IXN9
         3fFkmORycLFw5fxtY8RhSmzWUUO92NCSCrZT48d9Oongd22W1kzJuMZULOsrlI8Rms0L
         ZhdBR3vDHJrVj3FuwXbxVJZsn/+P9tlVt2oVshKe8jJQWo//Q5rckW5iabwCR2Po0Xml
         pBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sva5Znt/VDeW7J0KbuIeEzKeZPgyEyCu17zk6tnMZBc=;
        b=AsOjrKF10sWjY0lAhn45MdYuRvD3NSOYRFHIguZazxlIRcS/4kM6hkT0naRHFkBH+4
         BAhmXCQlGMjyyeU+pYMkqfrowyXC5pOmUfFx6KXrzmLhAwmBzz5RTAOYkUNp38dhXkpr
         NBP7dwGyULal5oDBgyWGKE8JFVMhyedG5SQ1QlKZvA/L/JYiuCDGyTdilUBTP9bOR1yk
         F/QDwRefw40x6K48wBR04U1KxnBAkVtSPrzQ4bHoYGH69uGxgKIynWAX+rr75aKx9MZn
         x3ePh8zJbLq64bgFvABuYz8FPjcS7dzVjtpiOBfmNSaooUJfVs1k8l1buCoAtI9cUknl
         TDaA==
X-Gm-Message-State: APjAAAUj2fWUL7ikmrfZhldXYMxbZcIZhWGsfnCSd18ned4s41YG7MsM
        Valijmqf48kvvP0vIq3ZS2ESytwB/rQ=
X-Google-Smtp-Source: APXvYqwgqzKybpXmRUGPIet/dGBCgAyFguKRNnUZZqs4IuAb7oQWopP4FMnBhPyl1Ig2sw0n0kATWQ==
X-Received: by 2002:a62:7b54:: with SMTP id w81mr6015198pfc.127.1578502217606;
        Wed, 08 Jan 2020 08:50:17 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c14sm4234390pfn.8.2020.01.08.08.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 08:50:17 -0800 (PST)
Subject: Re: io_uring and spurious wake-ups from eventfd
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     io-uring@vger.kernel.org
References: <d949ea3a-bd24-e597-b230-89b7075544cc@kernel.dk>
 <02106C23-C466-4E63-B881-AF8E6BDF9235@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f0c6bab5-3fd3-a3c5-8924-62adb419a865@kernel.dk>
Date:   Wed, 8 Jan 2020 09:50:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <02106C23-C466-4E63-B881-AF8E6BDF9235@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/8/20 9:46 AM, Mark Papadakis wrote:
> Thus sounds perfect!

I'll try and cook this up, if you can test it.

-- 
Jens Axboe

