Return-Path: <io-uring+bounces-13206-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id TcH5IlTR9WmcPQIAu9opvQ
	(envelope-from <io-uring+bounces-13206-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 12:26:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE644B1AC9
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 12:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 45167300442E
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2026 10:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B97843290AF;
	Sat,  2 May 2026 10:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r2qBovBV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B9D327C08
	for <io-uring@vger.kernel.org>; Sat,  2 May 2026 10:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777717582; cv=none; b=i0glU4ZOY2wDzI4tUrgON/vr7LBjXSzplMZyYRk1C4d+WD1A07qOk97gTc2al9iPtykg6+TTHSLP7d1UgWaZBR1oDCm/KAnDT8oe/vbHrePyGlp0K37vOyUx7UrBdHpM2b7bOZvCT/ZSJ5+Xg6eslO/Q3fepU5sLkps1QXe3tCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777717582; c=relaxed/simple;
	bh=5VDOAmL20Fz9qlrG8G7ceYj64eJKUyoGVE8PuemoHF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RL7fVgzGzn4sL7PCyT+M6Oh83vJLDKiwZr+AYVT/7Gp8TPgB8/rBD8T00gasFIIQ112+cYzM141l0U3fWIQmudO/ZvonkrMNTP4j1pKzt4IbdncfseT3UGa+xwG7VmBi4OSMJtANSaK3L4FwmLjplMz6aZAK90wGUc7Eq+QcMgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r2qBovBV; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4890d945eb4so20245455e9.0
        for <io-uring@vger.kernel.org>; Sat, 02 May 2026 03:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777717579; x=1778322379; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r3aqw4pxo6mHF7QSikvhQnxY0ABm84nxT4/Oyu1pc9E=;
        b=r2qBovBVMzcKJIMkzCKJdTQNFnqw52hTNYYa3G6vKjQc2dhShm3b5c2kQ4cp5exHxR
         XzQiX134/9zO8EUZddyI8Pzlye+USEFFiyA79LX3Uk7ql1nmPdZhac3X98WAJyGiMfBR
         wXtAG659uOIZF9xobW0gJQmr7eeDIfe8y2zAkVaCjFmP8QtJllBct9uP0iwlcxw4bSFX
         NELdJB+PSM0UBit1huIWX2wEd0kdGTSwsSEoGvksi0rECl+ivV1vBiPb5qOZBiSx7Qfk
         4sFM8lDbdfh9BxYip0s7GiM2Jckjp/jlqGyLoVKvodFAYnYCoNyj+NpU+pfF+l4AMnSd
         jDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777717579; x=1778322379;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r3aqw4pxo6mHF7QSikvhQnxY0ABm84nxT4/Oyu1pc9E=;
        b=GnNZCF40RQEkNhbel/UyotITGs3JQ+yukKiPSC4x72bbIbkvfEIo5mbDRN/jh+pUGE
         m+AnGL4MV6r10xGEumJpqtq+GjSJd1g1ntsTWq3wH9VXNs7VGp/ADzvhJkf00ESIafvW
         a11HelHfITOadi0z6Qc/KPgeVa47JTLVzQK3McZvxy/qMFl3j6lSwg/CjGwvTR2NhrUT
         Zw6C9SeQTQzDQURQ8eIxfWjI6FUGekUZaPyyjoo0BGHQhFN1TqFnvMDKFKIfNp27lUfH
         K8dTRgqRAjzzqWEMx9m2CftEtELV8XJAGFvu9gSFmGuQCC9gCvUti3I1MSn+jU+QPRjE
         2yWg==
X-Forwarded-Encrypted: i=1; AFNElJ8g+0EQGpzshYrxMeaql9cq3IOta5oTNWX1iDmYGmECtpxP+OUEn/Awxb+ieqNjdTz6NlkctjhwUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEa9n0rSTXpVfaRdF5mxpWfZW8Muh3xwmQpVsUZXCt39RTbB74
	WqKicS05/uG8HYblrOPpZNs9zsQrbAKudP7Wkuk9UoSu0T99mJi/gE8b
X-Gm-Gg: AeBDietlK5I6A0AqDIlMWdoTewJk7DPqO2naoCNuDqW+qGlCJhQF+NFRbJuQHacvoXP
	8ZFY+n6H5hzldQK/5erXOAnIvZr+e13SXyWQLizUmzZY6GXu08GJXQrVE6PgmtvfkS/ul+iVyBu
	Xs3RsOvN6OYmyQH5kJM+6/QGLnIiHioykc7eO5GguYlaQW5oaoFywyakw5bwwDsItFE8gv9wKfR
	Ru4hgOzL1+I7A4Vu2ySgoZc42QfX/4NarqAI6J019VmaQIkB8Cad4WciCglW8QqOvoDgMvrs7ys
	SFSxhzC1tBzazrum/MRg3p9KmXdxzquwvk1TT5eXIDjUy0V2gg+Vnbiey7+b/xQikKVtQ/NJBRW
	OAh1nvHtn+rflC1sfIohnUCRIotMzZCkfCUfmFDVs083QrpiHbdd1F9AYkELXTyl5k1IG34ssXd
	Vkpkdi3lcDCK/431KJ8/Of+24O+Xvvb3Ajb0SmnGPKzkuiCXgeI7k3fPCSYCO+is7/uEHvfgddl
	Ou4PKiz5HVLyV4IdwzpLpF7Hc5qCoJIsXeCLzknr22SU655vRRgk/rEdJs4bph+
X-Received: by 2002:a05:600c:8b11:b0:48a:5339:a46 with SMTP id 5b1f17b1804b1-48a970eafbemr38000475e9.9.1777717579260;
        Sat, 02 May 2026 03:26:19 -0700 (PDT)
Received: from [10.109.92.8] (82-132-229-207.dab.02.net. [82.132.229.207])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8ebc4201sm192896505e9.15.2026.05.02.03.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2026 03:26:18 -0700 (PDT)
Message-ID: <85b63dbc-1fb3-4913-9419-90908c5b6358@gmail.com>
Date: Sat, 2 May 2026 11:26:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: should IORING_TIMEOUT_ABS honour the submitter's time
 namespace?
To: Xie Maoyi <maoyi.xie@ntu.edu.sg>, Jens Axboe <axboe@kernel.dk>
Cc: Andrei Vagin <avagin@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <TYZPR01MB67582BE6855BE725AA5174CBDC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <TYZPR01MB67582BE6855BE725AA5174CBDC332@TYZPR01MB6758.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6DE644B1AC9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	SUBJECT_ENDS_QUESTION(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13206-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On 5/2/26 10:21, Xie Maoyi wrote:
> Hi all,
> 
> I think I have found what might be a bug in io_uring's absolute-deadline path on v7.0 mainline, and I would appreciate your confirmation on whether it is actually a bug and whether it is worth fixing.

timerfd seems to adjust it with timens_ktime_to_host(), maybe something
like below should do it, _not_ tested. FWIW, IORING_TIMEOUT_ABS is
much older than 7.0.


diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 4cfdfc519770..184d81a1d594 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -3,6 +3,7 @@
  #include <linux/errno.h>
  #include <linux/file.h>
  #include <linux/io_uring.h>
+#include <linux/time_namespace.h>
  
  #include <trace/events/io_uring.h>
  
@@ -35,6 +36,27 @@ struct io_timeout_rem {
  	bool				ltimeout;
  };
  
+static clockid_t io_flags_to_clock(unsigned flags)
+{
+	switch (flags & IORING_TIMEOUT_CLOCK_MASK) {
+	case IORING_TIMEOUT_BOOTTIME:
+		return CLOCK_BOOTTIME;
+	case IORING_TIMEOUT_REALTIME:
+		return CLOCK_REALTIME;
+	default:
+		/* can't happen, vetted at prep time */
+		WARN_ON_ONCE(1);
+		fallthrough;
+	case 0:
+		return CLOCK_MONOTONIC;
+	}
+}
+
+static clockid_t io_timeout_get_clock(struct io_timeout_data *data)
+{
+	return io_flags_to_clock(data->flags);
+}
+
  static int io_parse_user_time(ktime_t *time, u64 arg, unsigned flags)
  {
  	struct timespec64 ts;
@@ -43,7 +65,7 @@ static int io_parse_user_time(ktime_t *time, u64 arg, unsigned flags)
  		*time = ns_to_ktime(arg);
  		if (*time < 0)
  			return -EINVAL;
-		return 0;
+		goto out;
  	}
  
  	if (get_timespec64(&ts, u64_to_user_ptr(arg)))
@@ -51,6 +73,9 @@ static int io_parse_user_time(ktime_t *time, u64 arg, unsigned flags)
  	if (ts.tv_sec < 0 || ts.tv_nsec < 0)
  		return -EINVAL;
  	*time = timespec64_to_ktime(ts);
+out:
+	if (flags & IORING_TIMEOUT_ABS)
+		*time = timens_ktime_to_host(io_flags_to_clock(flags), *time);
  	return 0;
  }
  
@@ -397,22 +422,6 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
  	return HRTIMER_NORESTART;
  }
  
-static clockid_t io_timeout_get_clock(struct io_timeout_data *data)
-{
-	switch (data->flags & IORING_TIMEOUT_CLOCK_MASK) {
-	case IORING_TIMEOUT_BOOTTIME:
-		return CLOCK_BOOTTIME;
-	case IORING_TIMEOUT_REALTIME:
-		return CLOCK_REALTIME;
-	default:
-		/* can't happen, vetted at prep time */
-		WARN_ON_ONCE(1);
-		fallthrough;
-	case 0:
-		return CLOCK_MONOTONIC;
-	}
-}
-
  static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
  				    ktime_t ts, enum hrtimer_mode mode)
  	__must_hold(&ctx->timeout_lock)

-- 
Pavel Begunkov


