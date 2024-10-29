Return-Path: <io-uring+bounces-4132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 300DE9B5038
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA8E0284935
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C66E1D356C;
	Tue, 29 Oct 2024 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Lxs/REA4"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4062107;
	Tue, 29 Oct 2024 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222323; cv=none; b=OkBvDcZf5YK178TJSWe3wKgT5y3epeiOjE++8zFHrCXaAblur7AGipKF0rK+kjEZmKTe7/F+7i6WykqJGQ88COEX1a2O7ZKhOLzVy63zLmnPU/xiOaSf1ET1HR6IHFEOQhLh98b7ugQfZs8wLBvE7NJwonjkEBcybCeNyZddrd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222323; c=relaxed/simple;
	bh=2D/7DMDIkv5CaFUJ/6cNHz29ejsYbKwAcaknwspeL6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lseb0ZoRfHyNR4sXJ4Ypgkhv3Lc6dU0NwrGrznf7NBKcEe80D3Mn0okeH+68REJEAUN+KhPpGcibM6L/rCGAaYKL8xuQYQtIwp0AeqOxGiYtVCns9Ti1b/3IEpnN5aIhagoFaE8kizHPONtzIsoKwKWWhp358dWEj/+wNrh+3lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Lxs/REA4; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XdH682yjwzlgMVd;
	Tue, 29 Oct 2024 17:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730222315; x=1732814316; bh=Os+S4pHy7trxPWBaGt6FASH6
	K1G9Xgdn5eNIwNX8SiE=; b=Lxs/REA4wylfESXkATPL24Gb7eQfk4klgZJ/W5Zu
	g+KzwFz9gVBXOtBtfqFAiZ+hZUAcRkkKrssAcminMzwVZ61rhk8fpZEDtyf4IToe
	Wj7Uh+Qua9StMJ+JUx7I/A7lwfpQ7NkhDKIOtB22OgNR15iavT4EcLifRvXtR6ZP
	Z+W5dtY20asvPZMxFuDTcs5+8L5r6LptxN6IX08H4j2L5r08jI2WImkyV2garTV/
	4m+oKY6OzZQFfMulGQfKErmZrMJ+MW/lu28Yr10FOi8l2jqoeyKBtz2cTuFdwRUk
	xsdn+hWJbpaZ1FOKEru9zO9fSrbZaJ/hgskRh11QpEg9qQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sPa9noDahnIv; Tue, 29 Oct 2024 17:18:35 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XdH606Yv3zlgMVY;
	Tue, 29 Oct 2024 17:18:32 +0000 (UTC)
Message-ID: <343c29f2-59d6-48c5-937f-a02775b192ae@acm.org>
Date: Tue, 29 Oct 2024 10:18:31 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, io-uring@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, javier.gonz@samsung.com,
 Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
References: <20241029151922.459139-1-kbusch@meta.com>
 <20241029151922.459139-10-kbusch@meta.com> <20241029152654.GC26431@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241029152654.GC26431@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 8:26 AM, Christoph Hellwig wrote:
> Bart, btw: I think the current sd implementation is buggy as well, as
> it assumes the permanent streams are ordered by their data temperature
> in the IO Advise hints mode page, but I can't find anything in the
> spec that requires a particular ordering.

How about modifying sd_read_io_hints() such that permanent stream
information is ignored if the order of the RELATIVE LIFETIME information
reported by the GET STREAM STATUS command does not match the permanent
stream order?

Thanks,

Bart.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 41e2dfa2d67d..277035febd82 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3192,7 +3192,12 @@ sd_read_cache_type(struct scsi_disk *sdkp, 
unsigned char *buffer)
  	sdkp->DPOFUA = 0;
  }

-static bool sd_is_perm_stream(struct scsi_disk *sdkp, unsigned int 
stream_id)
+/*
+ * Returns the relative lifetime of a permanent stream. Returns -1 if the
+ * GET STREAM STATUS command fails or if the stream is not a permanent 
stream.
+ */
+static int sd_perm_stream_rel_lifetime(struct scsi_disk *sdkp,
+				       unsigned int stream_id)
  {
  	u8 cdb[16] = { SERVICE_ACTION_IN_16, SAI_GET_STREAM_STATUS };
  	struct {
@@ -3212,14 +3217,16 @@ static bool sd_is_perm_stream(struct scsi_disk 
*sdkp, unsigned int stream_id)
  	res = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, &buf, sizeof(buf),
  			       SD_TIMEOUT, sdkp->max_retries, &exec_args);
  	if (res < 0)
-		return false;
+		return -1;
  	if (scsi_status_is_check_condition(res) && scsi_sense_valid(&sshdr))
  		sd_print_sense_hdr(sdkp, &sshdr);
  	if (res)
-		return false;
+		return -1;
  	if (get_unaligned_be32(&buf.h.len) < sizeof(struct scsi_stream_status))
-		return false;
-	return buf.h.stream_status[0].perm;
+		return -1;
+	if (!buf.h.stream_status[0].perm)
+		return -1;
+	return buf.h.stream_status[0].rel_lifetime;
  }

  static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char 
*buffer)
@@ -3247,9 +3254,17 @@ static void sd_read_io_hints(struct scsi_disk 
*sdkp, unsigned char *buffer)
  	 * should assign the lowest numbered stream identifiers to permanent
  	 * streams.
  	 */
-	for (desc = start; desc < end; desc++)
-		if (!desc->st_enble || !sd_is_perm_stream(sdkp, desc - start))
+	int prev_rel_lifetime = -1;
+	for (desc = start; desc < end; desc++) {
+		int rel_lifetime;
+
+		if (!desc->st_enble)
  			break;
+		rel_lifetime = sd_perm_stream_rel_lifetime(sdkp, desc - start);
+		if (rel_lifetime < 0 || rel_lifetime < prev_rel_lifetime)
+			break;
+		prev_rel_lifetime = rel_lifetime;
+	}
  	permanent_stream_count_old = sdkp->permanent_stream_count;
  	sdkp->permanent_stream_count = desc - start;
  	if (sdkp->rscs && sdkp->permanent_stream_count < 2)


